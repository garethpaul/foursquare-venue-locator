# Foursquare Venue Location Trace Guard

status: completed

## Context

This repository is reserved for future ARKit, CoreLocation, and Foursquare venue
work. Device testing may produce GPX routes, GeoJSON/KML coordinate exports, or
local trace folders before the app exists. Those files can expose precise
locations and should not be committed as incidental sample data.

## Objectives

- Ignore common local location trace and simulator route artifacts.
- Fail the static baseline if raw GPX, GeoJSON, KML, or location-trace folders
  are tracked before the repo has a sanitized fixture policy.
- Document that future route fixtures must be deliberate, synthetic, and covered
  by the baseline instead of arriving as local test output.

## Verification

- `scripts/check-baseline.sh`
- `make check`
- `git diff --check`
