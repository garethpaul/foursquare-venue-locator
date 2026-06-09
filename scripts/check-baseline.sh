#!/usr/bin/env sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
PLAN="$ROOT_DIR/docs/plans/2026-06-08-foursquare-venue-locator-baseline.md"
PRIVACY_PLAN="$ROOT_DIR/docs/plans/2026-06-09-foursquare-venue-ios-privacy-keys.md"
IMPLEMENTATION_PLAN="$ROOT_DIR/docs/plans/2026-06-09-foursquare-venue-implementation-boundary.md"
CONFIG_PLAN="$ROOT_DIR/docs/plans/2026-06-09-foursquare-venue-local-config-template.md"
SIGNING_PLAN="$ROOT_DIR/docs/plans/2026-06-09-foursquare-venue-signing-artifact-guard.md"
LOCATION_TRACE_PLAN="$ROOT_DIR/docs/plans/2026-06-09-foursquare-venue-location-trace-guard.md"

require_file() {
  path=$1
  if [ ! -f "$ROOT_DIR/$path" ]; then
    printf '%s\n' "Required file missing: $path" >&2
    exit 1
  fi
}

for path in \
  ".gitignore" \
  ".env.example" \
  "CHANGES.md" \
  "Makefile" \
  "README.md" \
  "SECURITY.md" \
  "VISION.md" \
  "docs/readme-overview.svg" \
  "docs/plans/2026-06-09-foursquare-venue-implementation-boundary.md" \
  "docs/plans/2026-06-09-foursquare-venue-ios-privacy-keys.md" \
  "docs/plans/2026-06-09-foursquare-venue-location-trace-guard.md" \
  "docs/plans/2026-06-09-foursquare-venue-local-config-template.md" \
  "docs/plans/2026-06-09-foursquare-venue-signing-artifact-guard.md" \
  "docs/plans/2026-06-08-foursquare-venue-locator-baseline.md"; do
  require_file "$path"
done

if git -C "$ROOT_DIR" ls-files | grep -Eq '(^|/)\.DS_Store$|\.xcuser(state|datad)/|^DerivedData/'; then
  printf '%s\n' "Machine-local Apple and Finder artifacts must not be tracked." >&2
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

if ! grep -Fq "make check" "$ROOT_DIR/README.md" ||
  ! grep -Fq "FOURSQUARE_CLIENT_ID" "$ROOT_DIR/README.md" ||
  ! grep -Fq "FOURSQUARE_CLIENT_SECRET" "$ROOT_DIR/README.md" ||
  ! grep -Fq ".env.example" "$ROOT_DIR/README.md" ||
  ! grep -Fq "placeholder values" "$ROOT_DIR/README.md" ||
  ! grep -Fq "NSLocationWhenInUseUsageDescription" "$ROOT_DIR/README.md" ||
  ! grep -Fq "NSCameraUsageDescription" "$ROOT_DIR/README.md" ||
  ! grep -Fq "signing artifacts" "$ROOT_DIR/README.md" ||
  ! grep -Fq "location traces" "$ROOT_DIR/README.md" ||
  ! grep -Fq "docs-only baseline must be updated before app source" "$ROOT_DIR/README.md" ||
  ! grep -Fq "physical-device" "$ROOT_DIR/README.md"; then
  printf '%s\n' "README must document verification, credential names, iOS privacy keys, and device expectations." >&2
  exit 1
fi

if ! grep -Fq "scripts/check-baseline.sh" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "README now exists" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "Require camera and location purpose strings" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "non-secret .env.example" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "signing artifacts" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "local location traces" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "No app source, Xcode project" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "location data out of git" "$ROOT_DIR/VISION.md"; then
  printf '%s\n' "VISION must reflect the current baseline and privacy guardrails." >&2
  exit 1
fi

if ! grep -Fq "GitHub's private vulnerability reporting" "$ROOT_DIR/SECURITY.md" ||
  ! grep -Fq "No primary dependency manifest" "$ROOT_DIR/SECURITY.md" ||
  ! grep -Fq ".env.example" "$ROOT_DIR/SECURITY.md" ||
  ! grep -Fq "signing artifacts" "$ROOT_DIR/SECURITY.md" ||
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

printf '%s\n' "foursquare-venue-locator baseline checks passed."
