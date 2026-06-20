#!/usr/bin/env python3
import re
import subprocess
import sys
from dataclasses import dataclass
from pathlib import Path


class PolicyError(RuntimeError):
    pass


@dataclass(frozen=True)
class TrackedEntry:
    mode: str
    path: str


EXPECTED_ENV_ASSIGNMENTS = [
    ("FOURSQUARE_CLIENT_ID", "replace-with-your-client-id"),
    ("FOURSQUARE_CLIENT_SECRET", "replace-with-your-client-secret"),
]
CHECKOUT_REVISION = "df4cb1c069e1874edd31b4311f1884172cec0e10"
MAX_TRACKED_FILE_BYTES = 1_048_576


def git_output(root: Path, *arguments: str) -> bytes:
    return subprocess.run(
        ["git", "-C", str(root), *arguments],
        check=True,
        stdout=subprocess.PIPE,
    ).stdout


def tracked_entries(root: Path) -> list[TrackedEntry]:
    records = git_output(root, "ls-files", "-s", "-z").split(b"\0")
    entries = []
    for record in records:
        if not record:
            continue
        metadata, path_bytes = record.split(b"\t", 1)
        mode = metadata.split(b" ", 1)[0].decode("ascii")
        path = path_bytes.decode("utf-8", "surrogateescape")
        entries.append(TrackedEntry(mode=mode, path=path))
    return entries


def normalized_path(path: str) -> str:
    return path.replace("\\", "/").casefold()


def normalized_components(path: str) -> list[str]:
    return [re.sub(r"[-_. ]", "", part) for part in normalized_path(path).split("/")]


def reject_entry_type(entry: TrackedEntry) -> None:
    if entry.mode == "120000":
        raise PolicyError(f"tracked symlink is forbidden: {entry.path!r}")
    if entry.mode == "100755":
        path = normalized_path(entry.path)
        if not path.startswith("scripts/") or not path.endswith((".sh", ".py")):
            raise PolicyError(f"tracked executable is outside scripts: {entry.path!r}")
        return
    if entry.mode != "100644":
        raise PolicyError(f"tracked entry is not a regular file: {entry.path!r}")


def reject_sensitive_path(path: str) -> None:
    lowered = normalized_path(path)
    components = normalized_components(path)
    sensitive_suffixes = (
        ".mobileprovision",
        ".p12",
        ".cer",
        ".ipa",
        ".xcarchive",
        ".xcresult",
        ".p8",
        ".pfx",
        ".pem",
        ".key",
        ".gpx",
        ".geojson",
        ".kml",
        ".xcconfig",
        ".xcuserstate",
        ".xcuserdatad",
    )
    sensitive_components = {
        "deriveddata",
        "xcuserdata",
        "locationtraces",
        "cameracaptures",
        "camerarecordings",
    }
    if lowered == ".envrc" or lowered.endswith(sensitive_suffixes) or any(
        component in sensitive_components for component in components
    ):
        raise PolicyError(f"sensitive artifact path is forbidden: {path!r}")


def is_implementation_path(path: str) -> bool:
    lowered = normalized_path(path)
    components = normalized_components(path)
    implementation_suffixes = (
        ".swift",
        ".m",
        ".mm",
        ".h",
        ".hpp",
        ".c",
        ".cc",
        ".cpp",
        ".java",
        ".kt",
        ".kts",
        ".aidl",
        ".storyboard",
        ".xib",
        ".plist",
        ".entitlements",
    )
    implementation_names = {
        "podfile",
        "package.swift",
        "build.gradle",
        "build.gradle.kts",
        "settings.gradle",
        "settings.gradle.kts",
        "gradlew",
        "gradlew.bat",
    }
    return (
        lowered.endswith(implementation_suffixes)
        or lowered.rsplit("/", 1)[-1] in implementation_names
        or any(component in {"xcodeproj", "xcworkspace", "xcassets"} for component in components)
        or ".xcodeproj/" in lowered
        or ".xcworkspace/" in lowered
        or ".xcassets/" in lowered
    )


def reject_workflow_policy(root: Path, entries: list[TrackedEntry]) -> None:
    workflow_paths = [
        entry.path
        for entry in entries
        if normalized_path(entry.path).startswith(".github/workflows/")
        and normalized_path(entry.path).endswith((".yml", ".yaml"))
    ]
    if workflow_paths != [".github/workflows/check.yml"]:
        raise PolicyError("workflow policy requires exactly .github/workflows/check.yml")

    workflow = (root / workflow_paths[0]).read_text(encoding="utf-8")
    forbidden = (
        r"(?m)^\s*pull_request_target\s*:",
        r"\$\{\{\s*secrets\.",
        r"\$\{\{\s*github\.token\s*\}\}",
        r"(?mi)^\s*token\s*:",
        r"(?mi)^\s*permissions\s*:\s*write-all\s*$",
        r"(?mi)^\s*[a-z-]+\s*:\s*write\s*$",
    )
    if any(re.search(pattern, workflow) for pattern in forbidden):
        raise PolicyError("workflow contains privileged or secret-bearing configuration")
    if workflow.count("permissions:\n  contents: read") != 1:
        raise PolicyError("workflow must declare one top-level contents: read permission")
    if workflow.count("actions/checkout@") != 1:
        raise PolicyError("workflow must contain exactly one checkout action")
    if f"actions/checkout@{CHECKOUT_REVISION}" not in workflow:
        raise PolicyError("workflow checkout action must use the approved immutable revision")
    if workflow.count("persist-credentials: false") != 1:
        raise PolicyError("workflow checkout credentials must be disabled exactly once")
    required = ("pull_request:", "push:", "workflow_dispatch:", "timeout-minutes: 5", "run: make check")
    if any(item not in workflow for item in required):
        raise PolicyError("workflow is missing a required bounded check setting")


def reject_sensitive_content(path: str, content: bytes) -> None:
    if normalized_path(path) in {
        "scripts/check-baseline.sh",
        "scripts/check_repository_policy.py",
        "tests/test_repository_policy.py",
    }:
        return
    if re.search(rb"-----BEGIN (?:[A-Z0-9]+ )*PRIVATE KEY-----", content, re.IGNORECASE):
        raise PolicyError(f"tracked file contains private key material: {path!r}")
    if normalized_path(path) != ".env.example" and re.search(
        rb"(?:pk\.eyJ|fsq3[A-Za-z0-9_-]{8,}|client_(?:id|secret)\s*=)",
        content,
        re.IGNORECASE,
    ):
        raise PolicyError(f"tracked file contains raw provider credential material: {path!r}")

    lowered = normalized_path(path)
    if lowered.endswith((".plist", ".json", ".properties", ".xcconfig", ".env")):
        credential_key = re.compile(
            rb"(?:foursquare|fsq|client)[A-Za-z0-9_. -]{0,24}(?:secret|token|api[_. -]?key|client[_. -]?id)",
            re.IGNORECASE,
        )
        if credential_key.search(content):
            raise PolicyError(f"credential-bearing configuration container is forbidden: {path!r}")


def inspect_repository(root: Path) -> None:
    root = root.resolve()
    entries = tracked_entries(root)
    paths = {entry.path for entry in entries}
    required = {".env.example", ".github/workflows/check.yml"}
    if not required.issubset(paths):
        raise PolicyError("required policy files are not tracked")

    reject_workflow_policy(root, entries)
    for entry in entries:
        reject_entry_type(entry)
        reject_sensitive_path(entry.path)
        path = root / entry.path
        size = path.stat().st_size
        if size > MAX_TRACKED_FILE_BYTES:
            raise PolicyError(f"tracked file exceeds the documentation-only size bound: {entry.path!r}")
        content = path.read_bytes()
        reject_sensitive_content(entry.path, content)
        if is_implementation_path(entry.path):
            raise PolicyError(f"implementation artifact requires a new reviewed baseline: {entry.path!r}")

    env_path = root / ".env.example"
    assignments = []
    for line in env_path.read_text(encoding="utf-8").splitlines():
        if not line or line.startswith("#"):
            continue
        match = re.fullmatch(r"([A-Z][A-Z0-9_]*)=([^\s]+)", line)
        if not match:
            raise PolicyError("environment template contains non-declarative syntax")
        assignments.append(match.groups())
    if assignments != EXPECTED_ENV_ASSIGNMENTS:
        raise PolicyError("environment template must contain the exact two placeholder assignments")
    env_entry = next(entry for entry in entries if entry.path == ".env.example")
    if env_entry.mode != "100644":
        raise PolicyError("environment template must be a regular non-executable file")


def main() -> int:
    root = Path(sys.argv[1]) if len(sys.argv) > 1 else Path(__file__).resolve().parent.parent
    try:
        inspect_repository(root)
    except (OSError, subprocess.CalledProcessError, UnicodeError, PolicyError) as error:
        print(f"repository policy failed: {error}", file=sys.stderr)
        return 1
    print("repository policy checks passed")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
