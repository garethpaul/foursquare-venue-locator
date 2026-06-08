#!/usr/bin/env sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
PLAN="$ROOT_DIR/docs/plans/2026-06-08-foursquare-venue-locator-baseline.md"

require_file() {
  path=$1
  if [ ! -f "$ROOT_DIR/$path" ]; then
    printf '%s\n' "Required file missing: $path" >&2
    exit 1
  fi
}

for path in \
  ".gitignore" \
  "CHANGES.md" \
  "Makefile" \
  "README.md" \
  "SECURITY.md" \
  "VISION.md" \
  "docs/readme-overview.svg" \
  "docs/plans/2026-06-08-foursquare-venue-locator-baseline.md"; do
  require_file "$path"
done

if git -C "$ROOT_DIR" ls-files | grep -Eq '(^|/)\.DS_Store$|\.xcuser(state|datad)/|^DerivedData/'; then
  printf '%s\n' "Machine-local Apple and Finder artifacts must not be tracked." >&2
  exit 1
fi

if git -C "$ROOT_DIR" grep -nE 'pk\.eyJ|client_secret=|client_id=|fsq3[A-Za-z0-9_-]+' -- . ':!scripts/check-baseline.sh'; then
  printf '%s\n' "Tracked files must not contain raw Foursquare, Mapbox, or query-string credentials." >&2
  exit 1
fi

if ! grep -Fq "make check" "$ROOT_DIR/README.md" ||
  ! grep -Fq "FOURSQUARE_CLIENT_ID" "$ROOT_DIR/README.md" ||
  ! grep -Fq "FOURSQUARE_CLIENT_SECRET" "$ROOT_DIR/README.md" ||
  ! grep -Fq "physical-device" "$ROOT_DIR/README.md"; then
  printf '%s\n' "README must document verification, credential names, and device expectations." >&2
  exit 1
fi

if ! grep -Fq "scripts/check-baseline.sh" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "README now exists" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "location data out of git" "$ROOT_DIR/VISION.md"; then
  printf '%s\n' "VISION must reflect the current baseline and privacy guardrails." >&2
  exit 1
fi

if ! grep -Fq "GitHub's private vulnerability reporting" "$ROOT_DIR/SECURITY.md" ||
  ! grep -Fq "No primary dependency manifest" "$ROOT_DIR/SECURITY.md"; then
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

printf '%s\n' "foursquare-venue-locator baseline checks passed."
