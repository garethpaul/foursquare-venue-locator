import os
import stat
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from scripts.check_repository_policy import PolicyError, inspect_repository


class RepositoryPolicyTests(unittest.TestCase):
    def setUp(self):
        self.temporary_directory = tempfile.TemporaryDirectory()
        self.root = Path(self.temporary_directory.name)
        subprocess.run(["git", "init", "-q", str(self.root)], check=True)
        self.write(
            ".env.example",
            "FOURSQUARE_CLIENT_" "ID=replace-with-your-client-id\n"
            "FOURSQUARE_CLIENT_" "SECRET=replace-with-your-client-secret\n",
        )
        self.write(
            ".github/workflows/check.yml",
            """name: Check
on:
  pull_request:
  push:
  workflow_dispatch:
permissions:
  contents: read
jobs:
  check:
    runs-on: ubuntu-24.04
    timeout-minutes: 5
    steps:
      - uses: actions/checkout@df4cb1c069e1874edd31b4311f1884172cec0e10
        with:
          persist-credentials: false
      - run: make check
""",
        )
        self.write("README.md", "documentation only\n")
        self.git("add", ".")

    def tearDown(self):
        self.temporary_directory.cleanup()

    def git(self, *arguments):
        subprocess.run(["git", "-C", str(self.root), *arguments], check=True)

    def write(self, relative_path, content, mode=None):
        path = self.root / relative_path
        path.parent.mkdir(parents=True, exist_ok=True)
        if isinstance(content, bytes):
            path.write_bytes(content)
        else:
            path.write_text(content)
        if mode is not None:
            path.chmod(mode)
        return path

    def assert_rejected(self, message):
        with self.assertRaisesRegex(PolicyError, message):
            inspect_repository(self.root)

    def test_accepts_minimal_documentation_only_repository(self):
        inspect_repository(self.root)

    def test_rejects_tracked_symlink_even_when_target_is_regular(self):
        os.symlink("README.md", self.root / "SECURITY.md")
        self.git("add", "SECURITY.md")
        self.assert_rejected("symlink")

    def test_rejects_case_variant_sensitive_artifact_paths(self):
        for relative_path in (
            "Config.XCCONFIG",
            "Keys/Auth.P8",
            "Routes/Trip.GPX",
            "CAMERACAPTURES/frame.jpg",
        ):
            with self.subTest(relative_path=relative_path):
                path = self.write(relative_path, "placeholder\n")
                self.git("add", relative_path)
                self.assert_rejected("sensitive artifact")
                self.git("reset", "-q", "--", relative_path)
                path.unlink()

    def test_rejects_case_variant_implementation_artifacts(self):
        for relative_path in (
            "App/Scene.M",
            "App/Scene.KT",
            "App/Info.PLIST",
            "App/BUILD.GRADLE",
            "App/Assets.XCASSETS/Contents.json",
        ):
            with self.subTest(relative_path=relative_path):
                path = self.write(relative_path, "placeholder\n")
                self.git("add", relative_path)
                self.assert_rejected("implementation artifact")
                self.git("reset", "-q", "--", relative_path)
                path.unlink()

    def test_rejects_secret_bearing_configuration_containers(self):
        fixtures = {
            "Config/provider.plist": "<key>FOURSQUARE_CLIENT_SECRET</key><string>not-a-real-secret</string>\n",
            "Config/provider.json": '{"client_secret":"not-a-real-secret"}\n',
            "Config/provider.properties": "foursquare.api.key=not-a-real-secret\n",
        }
        for relative_path, content in fixtures.items():
            with self.subTest(relative_path=relative_path):
                path = self.write(relative_path, content)
                self.git("add", relative_path)
                self.assert_rejected("credential-bearing configuration")
                self.git("reset", "-q", "--", relative_path)
                path.unlink()

    def test_rejects_private_key_marker_in_binary_blob(self):
        self.write("docs/blob.bin", b"\x00-----BEGIN " + b"PRIVATE KEY-----\x00")
        self.git("add", "docs/blob.bin")
        self.assert_rejected("private key material")

    def test_rejects_secret_material_in_policy_files(self):
        fixtures = {
            "scripts/check-baseline.sh": (
                "#!/bin/sh\nprintf '%s\\n' '" + "fsq" + "3RealLookingCredential'\n"
            ),
            "scripts/check_repository_policy.py": (
                "API_KEY = '" + "pk." + "eyJRealLookingCredential'\n"
            ),
            "tests/test_repository_policy.py": (
                "LEAK = b'" + "-----BEGIN " + "PRIVATE KEY-----" + "'\n"
            ),
        }
        for relative_path, content in fixtures.items():
            with self.subTest(relative_path=relative_path):
                path = self.write(relative_path, content)
                self.git("add", relative_path)
                self.assert_rejected("credential|private key")
                self.git("reset", "-q", "--", relative_path)
                path.unlink()

    def test_rejects_newline_path_that_hides_sensitive_suffix(self):
        relative_path = "docs/notes\nSecrets.PEM"
        self.write(relative_path, "placeholder\n")
        self.git("add", relative_path)
        self.assert_rejected("sensitive artifact")

    def test_rejects_executable_or_non_blob_tracked_entries(self):
        path = self.write("docs/runbook.md", "safe\n", stat.S_IRUSR | stat.S_IWUSR | stat.S_IXUSR)
        self.git("add", "docs/runbook.md")
        self.assert_rejected("executable")
        path.chmod(stat.S_IRUSR | stat.S_IWUSR)

    def test_rejects_privileged_or_secret_bearing_workflow(self):
        invalid_fragments = (
            "pull_request_target:",
            "  contents: write",
            "          token: ${{ secrets.GITHUB_TOKEN }}",
            "      - run: echo ${{ secrets.FOURSQUARE_CLIENT_SECRET }}",
            "permissions: write-all",
        )
        workflow = (self.root / ".github/workflows/check.yml").read_text()
        for fragment in invalid_fragments:
            with self.subTest(fragment=fragment):
                (self.root / ".github/workflows/check.yml").write_text(workflow + fragment + "\n")
                self.git("add", ".github/workflows/check.yml")
                self.assert_rejected("workflow")
        (self.root / ".github/workflows/check.yml").write_text(workflow)

    def test_rejects_non_placeholder_environment_schema(self):
        (self.root / ".env.example").write_text(
            "FOURSQUARE_CLIENT_" "ID=replace-with-your-client-id\n"
            "FOURSQUARE_CLIENT_" "SECRET=changed-value\n"
        )
        self.git("add", ".env.example")
        self.assert_rejected("environment template")


if __name__ == "__main__":
    unittest.main()
