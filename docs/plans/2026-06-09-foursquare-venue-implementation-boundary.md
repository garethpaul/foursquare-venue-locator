# Foursquare Venue Implementation Boundary

status: completed

## Context

This repository is still documentation-only. Future ARKit, CoreLocation, and
Foursquare work will add app source, Xcode project files, dependency manifests,
and physical-device verification requirements. Those files should not appear as
silent scaffolding without updating the baseline that currently describes this
repo as a placeholder.

## Objectives

- Keep the current docs-only repository state explicit.
- Fail the static baseline if Swift source, Xcode project/workspace files, or
  primary Apple dependency manifests appear before the baseline is updated.
- Document that future implementation changes must include verification,
  privacy, credential, and dependency guidance.

## Verification

- `scripts/check-baseline.sh`
- `make check`
- `git diff --check`
