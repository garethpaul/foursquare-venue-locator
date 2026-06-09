# Foursquare Venue Signing Artifact Guard

status: completed

## Context

This repository is still documentation-only, but future iOS work will introduce
an Xcode project, signing configuration, device builds, and exported artifacts.
Provisioning profiles, certificates, archives, IPAs, and result bundles are
local or sensitive outputs and should not become part of the public sample.

## Objectives

- Ignore common Apple signing, archive, IPA, and result bundle artifacts.
- Fail the static baseline if those artifact types are tracked.
- Document the signing and export artifact boundary in README, VISION,
  SECURITY, and CHANGES.
- Preserve the docs-only implementation boundary until app source lands.

## Verification

- `scripts/check-baseline.sh`
- `make check`
- `git diff --check`
