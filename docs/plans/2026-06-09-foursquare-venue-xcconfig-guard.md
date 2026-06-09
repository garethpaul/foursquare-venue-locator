---
title: Foursquare Venue Xcconfig Guard
date: 2026-06-09
status: completed
execution: docs
---

## Context

The repository already ignores `*.xcconfig` because future iOS work may use
local Xcode build settings for Foursquare credentials, signing configuration,
or machine-specific paths. The docs-only baseline did not yet verify that
contract.

## Goals

- Fail the baseline if local `.xcconfig` build-setting files are tracked.
- Fail the baseline if the `*.xcconfig` ignore rule is removed.
- Document the local Xcode build-setting boundary in README, SECURITY, and
  VISION.
- Preserve the docs-only implementation boundary until app source lands.

## Implementation

- Added tracked-file and ignore-rule checks to `scripts/check-baseline.sh`.
- Updated README, SECURITY, VISION, and CHANGES.
- Recorded this completed guardrail plan.

## Verification

- `sh -n scripts/check-baseline.sh`
- `scripts/check-baseline.sh`
- `make lint`
- `make test`
- `make build`
- `make check`
- `git diff --check`
