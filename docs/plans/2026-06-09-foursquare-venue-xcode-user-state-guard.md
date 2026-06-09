---
title: Foursquare Venue Xcode User State Guard
date: 2026-06-09
status: completed
execution: docs
---

## Context

The placeholder repository already ignored broad Apple local artifacts, signing
outputs, and location traces. Future Xcode work can also generate
`*.xcuserstate`, `*.xcuserdatad`, and `xcuserdata/` files that include local
workspace state, personal paths, or device-specific settings.

## Goals

- Explicitly ignore Xcode user-state files and workspace user data.
- Keep those artifacts out of the docs-only baseline until app source lands.
- Document the local-artifact boundary in README, VISION, and SECURITY.
- Extend static verification so the ignore rules remain visible.

## Implementation

- Added `*.xcuserstate` and `*.xcuserdatad` to `.gitignore`.
- Tightened the tracked-file guard for Xcode user-state artifacts.
- Extended `scripts/check-baseline.sh`, README, SECURITY, VISION, and CHANGES.

## Verification

- `scripts/check-baseline.sh`
- `make check`
- `make lint`
- `make test`
- `make build`
- `git diff --check`
