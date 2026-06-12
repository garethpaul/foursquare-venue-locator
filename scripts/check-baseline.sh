#!/usr/bin/env sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
PLAN="$ROOT_DIR/docs/plans/2026-06-08-foursquare-venue-locator-baseline.md"
PRIVACY_PLAN="$ROOT_DIR/docs/plans/2026-06-09-foursquare-venue-ios-privacy-keys.md"
IMPLEMENTATION_PLAN="$ROOT_DIR/docs/plans/2026-06-09-foursquare-venue-implementation-boundary.md"
CONFIG_PLAN="$ROOT_DIR/docs/plans/2026-06-09-foursquare-venue-local-config-template.md"
SIGNING_PLAN="$ROOT_DIR/docs/plans/2026-06-09-foursquare-venue-signing-artifact-guard.md"
LOCATION_TRACE_PLAN="$ROOT_DIR/docs/plans/2026-06-09-foursquare-venue-location-trace-guard.md"
MAKE_GATES_PLAN="$ROOT_DIR/docs/plans/2026-06-09-foursquare-venue-make-gate-aliases.md"
XCODE_USER_STATE_PLAN="$ROOT_DIR/docs/plans/2026-06-09-foursquare-venue-xcode-user-state-guard.md"
LOCAL_ENVRC_PLAN="$ROOT_DIR/docs/plans/2026-06-09-foursquare-venue-envrc-guard.md"
LOCAL_XCCONFIG_PLAN="$ROOT_DIR/docs/plans/2026-06-09-foursquare-venue-xcconfig-guard.md"
CAMERA_OUTPUT_PLAN="$ROOT_DIR/docs/plans/2026-06-10-foursquare-venue-camera-output-guard.md"
CI_PLAN="$ROOT_DIR/docs/plans/2026-06-10-hosted-boundary-checks.md"
CREDENTIAL_PLAN="$ROOT_DIR/docs/plans/2026-06-12-checkout-credential-boundary.md"
CI_WORKFLOW="$ROOT_DIR/.github/workflows/check.yml"

require_file() {
  path=$1
  if [ ! -f "$ROOT_DIR/$path" ]; then
    printf '%s\n' "Required file missing: $path" >&2
    exit 1
  fi
}

for path in \
  ".github/workflows/check.yml" \
  ".gitignore" \
  ".env.example" \
  "CHANGES.md" \
  "Makefile" \
  "README.md" \
  "SECURITY.md" \
  "VISION.md" \
  "docs/readme-overview.svg" \
  "docs/plans/2026-06-09-foursquare-venue-implementation-boundary.md" \
  "docs/plans/2026-06-09-foursquare-venue-envrc-guard.md" \
  "docs/plans/2026-06-09-foursquare-venue-xcconfig-guard.md" \
  "docs/plans/2026-06-09-foursquare-venue-ios-privacy-keys.md" \
  "docs/plans/2026-06-09-foursquare-venue-location-trace-guard.md" \
  "docs/plans/2026-06-09-foursquare-venue-local-config-template.md" \
  "docs/plans/2026-06-09-foursquare-venue-make-gate-aliases.md" \
  "docs/plans/2026-06-09-foursquare-venue-signing-artifact-guard.md" \
  "docs/plans/2026-06-09-foursquare-venue-xcode-user-state-guard.md" \
  "docs/plans/2026-06-10-foursquare-venue-camera-output-guard.md" \
  "docs/plans/2026-06-08-foursquare-venue-locator-baseline.md" \
  "docs/plans/2026-06-10-hosted-boundary-checks.md"; do
  require_file "$path"
done

require_file "docs/plans/2026-06-12-checkout-credential-boundary.md"

makefile="$ROOT_DIR/Makefile"
if ! grep -Eq '^\.PHONY: .*build.*check.*lint.*test|^\.PHONY: .*build.*lint.*test.*check' "$makefile" ||
  ! grep -Fq "lint test build: check" "$makefile"; then
  printf '%s\n' "Makefile must expose lint, test, build, and check gate targets." >&2
  exit 1
fi

if git -C "$ROOT_DIR" ls-files | grep -Eq '(^|/)\.DS_Store$|(^|/)xcuserdata/|\.xcuserstate$|\.xcuserdatad/|^DerivedData/'; then
  printf '%s\n' "Machine-local Apple and Finder artifacts must not be tracked." >&2
  exit 1
fi

if git -C "$ROOT_DIR" ls-files | grep -Eq '(^|/)\.envrc$'; then
  printf '%s\n' "Local direnv credential files must not be tracked." >&2
  exit 1
fi

if git -C "$ROOT_DIR" ls-files | grep -Eq '\.xcconfig$'; then
  printf '%s\n' "Local Xcode build-setting files must not be tracked." >&2
  exit 1
fi

if git -C "$ROOT_DIR" ls-files | grep -Eq '\.(mobileprovision|p12|cer|ipa|xcarchive|xcresult)$'; then
  printf '%s\n' "Apple signing, archive, and result artifacts must not be tracked." >&2
  exit 1
fi

if git -C "$ROOT_DIR" ls-files | grep -Eq '\.swift$|\.xcodeproj/|\.xcworkspace/|(^|/)Podfile$|(^|/)Package.swift$'; then
  printf '%s\n' "Docs-only baseline must be updated before app source, Xcode projects, or dependency manifests land." >&2
  exit 1
fi

if git -C "$ROOT_DIR" ls-files | grep -Eq '\.(gpx|geojson|kml)$|(^|/)location-traces/|(^|/)LocationTraces/'; then
  printf '%s\n' "Local location traces and simulator routes must not be tracked." >&2
  exit 1
fi

if git -C "$ROOT_DIR" ls-files | grep -Eq '(^|/)(camera-captures|CameraCaptures|camera-recordings|CameraRecordings)/'; then
  printf '%s\n' "Local camera captures and recordings must not be tracked." >&2
  exit 1
fi

if git -C "$ROOT_DIR" grep -nE 'pk\.eyJ|client_secret=|client_id=|fsq3[A-Za-z0-9_-]+' -- . ':!scripts/check-baseline.sh'; then
  printf '%s\n' "Tracked files must not contain raw Foursquare, Mapbox, or query-string credentials." >&2
  exit 1
fi

if ! grep -Fxq "FOURSQUARE_CLIENT_ID=replace-with-your-client-id" "$ROOT_DIR/.env.example" ||
  ! grep -Fxq "FOURSQUARE_CLIENT_SECRET=replace-with-your-client-secret" "$ROOT_DIR/.env.example" ||
  grep -Eq 'pk\.eyJ|fsq3[A-Za-z0-9_-]+' "$ROOT_DIR/.env.example"; then
  printf '%s\n' ".env.example must contain only non-secret Foursquare placeholders." >&2
  exit 1
fi

for pattern in "*.mobileprovision" "*.p12" "*.cer" "*.ipa" "*.xcarchive" "*.xcresult"; do
  if ! grep -Fxq "$pattern" "$ROOT_DIR/.gitignore"; then
    printf '%s\n' ".gitignore must exclude Apple signing and export artifacts: $pattern" >&2
    exit 1
  fi
done

for pattern in "*.gpx" "*.geojson" "*.kml" "location-traces/" "LocationTraces/"; do
  if ! grep -Fxq "$pattern" "$ROOT_DIR/.gitignore"; then
    printf '%s\n' ".gitignore must exclude local location trace artifacts: $pattern" >&2
    exit 1
  fi
done

for pattern in "camera-captures/" "CameraCaptures/" "camera-recordings/" "CameraRecordings/"; do
  if ! grep -Fxq "$pattern" "$ROOT_DIR/.gitignore"; then
    printf '%s\n' ".gitignore must exclude local camera output: $pattern" >&2
    exit 1
  fi
done

for pattern in "*.xcuserstate" "*.xcuserdatad" "xcuserdata/"; do
  if ! grep -Fxq "$pattern" "$ROOT_DIR/.gitignore"; then
    printf '%s\n' ".gitignore must exclude local Xcode user-state artifacts: $pattern" >&2
    exit 1
  fi
done

if ! grep -Fxq ".envrc" "$ROOT_DIR/.gitignore"; then
  printf '%s\n' ".gitignore must exclude local direnv credential files." >&2
  exit 1
fi

if ! grep -Fxq "*.xcconfig" "$ROOT_DIR/.gitignore"; then
  printf '%s\n' ".gitignore must exclude local Xcode build-setting files." >&2
  exit 1
fi

if ! grep -Fq "make lint" "$ROOT_DIR/README.md" ||
  ! grep -Fq "make test" "$ROOT_DIR/README.md" ||
  ! grep -Fq "make build" "$ROOT_DIR/README.md" ||
  ! grep -Fq "make check" "$ROOT_DIR/README.md" ||
  ! grep -Fq "FOURSQUARE_CLIENT_ID" "$ROOT_DIR/README.md" ||
  ! grep -Fq "FOURSQUARE_CLIENT_SECRET" "$ROOT_DIR/README.md" ||
  ! grep -Fq ".env.example" "$ROOT_DIR/README.md" ||
  ! grep -Fq "placeholder values" "$ROOT_DIR/README.md" ||
  ! grep -Fq ".envrc" "$ROOT_DIR/README.md" ||
  ! grep -Fq "*.xcconfig" "$ROOT_DIR/README.md" ||
  ! grep -Fq "NSLocationWhenInUseUsageDescription" "$ROOT_DIR/README.md" ||
  ! grep -Fq "NSCameraUsageDescription" "$ROOT_DIR/README.md" ||
  ! grep -Fq "signing artifacts" "$ROOT_DIR/README.md" ||
  ! grep -Fq "Xcode user-state" "$ROOT_DIR/README.md" ||
  ! grep -Fq "location traces" "$ROOT_DIR/README.md" ||
  ! grep -Fq "docs-only baseline must be updated before app source" "$ROOT_DIR/README.md" ||
  ! grep -Fq "physical-device" "$ROOT_DIR/README.md"; then
  printf '%s\n' "README must document verification, credential names, iOS privacy keys, and device expectations." >&2
  exit 1
fi

if ! grep -Fq "scripts/check-baseline.sh" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "make lint" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "make test" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "make build" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "README now exists" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "Require camera and location purpose strings" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "non-secret .env.example" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq ".envrc" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "*.xcconfig" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "signing artifacts" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "Xcode user-state" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "local location traces" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "No app source, Xcode project" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "location data out of git" "$ROOT_DIR/VISION.md"; then
  printf '%s\n' "VISION must reflect the current baseline and privacy guardrails." >&2
  exit 1
fi

if ! grep -Fq "GitHub's private vulnerability reporting" "$ROOT_DIR/SECURITY.md" ||
  ! grep -Fq "No primary dependency manifest" "$ROOT_DIR/SECURITY.md" ||
  ! grep -Fq ".env.example" "$ROOT_DIR/SECURITY.md" ||
  ! grep -Fq ".envrc" "$ROOT_DIR/SECURITY.md" ||
  ! grep -Fq "*.xcconfig" "$ROOT_DIR/SECURITY.md" ||
  ! grep -Fq "signing artifacts" "$ROOT_DIR/SECURITY.md" ||
  ! grep -Fq "Xcode user-state" "$ROOT_DIR/SECURITY.md" ||
  ! grep -Fq "location traces" "$ROOT_DIR/SECURITY.md" ||
  ! grep -Fq "Future ARKit, CoreLocation, and camera code" "$ROOT_DIR/SECURITY.md"; then
  printf '%s\n' "SECURITY must keep reporting and dependency-scope guidance." >&2
  exit 1
fi

if ! grep -Fq '<title id="title">foursquare-venue-locator project overview</title>' "$ROOT_DIR/docs/readme-overview.svg"; then
  printf '%s\n' "README overview SVG must stay aligned with this repository." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$PLAN"; then
  printf '%s\n' "Plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$PRIVACY_PLAN"; then
  printf '%s\n' "iOS privacy-key plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$IMPLEMENTATION_PLAN"; then
  printf '%s\n' "Implementation boundary plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$CONFIG_PLAN"; then
  printf '%s\n' "Local config template plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$SIGNING_PLAN"; then
  printf '%s\n' "Signing artifact guard plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$LOCATION_TRACE_PLAN"; then
  printf '%s\n' "Location trace guard plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$MAKE_GATES_PLAN"; then
  printf '%s\n' "Make gate alias plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$XCODE_USER_STATE_PLAN"; then
  printf '%s\n' "Xcode user-state guard plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$LOCAL_ENVRC_PLAN"; then
  printf '%s\n' "Local envrc guard plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$LOCAL_XCCONFIG_PLAN"; then
  printf '%s\n' "Local xcconfig guard plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$CAMERA_OUTPUT_PLAN"; then
  printf '%s\n' "Camera output guard plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "make check" "$LOCAL_ENVRC_PLAN"; then
  printf '%s\n' "Local envrc guard plan must record make check verification." >&2
  exit 1
fi

if ! grep -Fq "make check" "$LOCAL_XCCONFIG_PLAN"; then
  printf '%s\n' "Local xcconfig guard plan must record make check verification." >&2
  exit 1
fi

if ! awk '
  /^[[:space:]]*uses:[[:space:]]*actions\/checkout@/ {
    checkout_count++
    if ($0 == "        uses: actions/checkout@df4cb1c069e1874edd31b4311f1884172cec0e10 # v6.0.2") state = 1
    else invalid = 1
    next
  }
  /^[[:space:]]*persist-credentials[[:space:]]*:/ { credential_count++ }
  /^        with:[[:space:]]*$/ { with_count++ }
  state == 1 && $0 == "        with:" { state = 2; next }
  state == 1 && /^[[:space:]]*(#.*)?$/ { next }
  state == 1 { invalid = 1; state = 0 }
  state == 2 && $0 == "          persist-credentials: false" { contract_count++; state = 0; next }
  state == 2 && /^[[:space:]]*(#.*)?$/ { next }
  state == 2 { invalid = 1; state = 0 }
  END {
    if (checkout_count != 1 || with_count != 1 || credential_count != 1 ||
        contract_count != 1 || invalid != 0) exit 1
  }
' "$CI_WORKFLOW"; then
  printf '%s\n' "Checkout must be uniquely pinned with credential persistence disabled." >&2
  exit 1
fi

if ! grep -Fq "workflow_dispatch:" "$CI_WORKFLOW" ||
  ! grep -Fq "contents: read" "$CI_WORKFLOW" ||
  ! grep -Fq "cancel-in-progress: true" "$CI_WORKFLOW" ||
  ! grep -Fq "runs-on: ubuntu-24.04" "$CI_WORKFLOW" ||
  ! grep -Fq "timeout-minutes: 5" "$CI_WORKFLOW" ||
  ! grep -Fq "run: make check" "$CI_WORKFLOW"; then
  printf '%s\n' "GitHub Actions must keep the bounded docs-only boundary check contract." >&2
  exit 1
fi

python3 - "$CREDENTIAL_PLAN" <<'PY'
import re
import sys
from pathlib import Path

plan = Path(sys.argv[1]).read_text()
frontmatter = plan.split("---", 2)[1]
statuses = re.findall(r"^status: .+$", frontmatter, flags=re.MULTILINE)
verification = plan.split("## Verification Completed\n", 1)[-1]
required = (
    "All four Make gates",
    "push run `27392652005`",
    "pull-request run `27392656600`",
    "push run `27392668931`",
    "CodeQL run `27402320622`",
)

if (
    statuses != ["status: completed"]
    or any(item not in verification for item in required)
    or re.search(r"\b(?:pending|todo|tbd|not run)\b", verification, re.IGNORECASE)
):
    raise SystemExit(
        "Checkout credential boundary plan must remain completed with actual verification recorded."
    )
PY

if ! grep -Fq "status: completed" "$CI_PLAN" ||
  ! grep -Fq "make check" "$CI_PLAN"; then
  printf '%s\n' "Hosted boundary checks plan must be completed and record verification." >&2
  exit 1
fi

printf '%s\n' "foursquare-venue-locator baseline checks passed."
