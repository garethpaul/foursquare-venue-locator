---
title: Location-Independent Venue Locator Verification
type: reliability
date: 2026-06-13
status: planned
execution: code
---

# Location-Independent Venue Locator Verification

## Summary

Resolve the maintained static checker from the loaded Makefile so every
documented gate works when Make is invoked outside the checkout.

## Requirements

- R1. Derive the repository root from `MAKEFILE_LIST`.
- R2. Invoke `scripts/check-baseline.sh` through its repository-rooted path.
- R3. Add a static contract that rejects caller-directory-relative invocation.
- R4. Preserve environment-template, credential, private-key, signing-artifact,
  project, workflow, privacy, and generated-artifact boundaries.
- R5. Record actual root and external-directory verification before completion.

## Verification Plan

- Run `make check`, `make lint`, `make test`, and `make build` at repository
  root and from `/tmp` through the absolute Makefile path.
- Reject isolated hostile root-derivation, checker-path, documentation,
  plan-status, and verification-evidence mutations.
- Run shell syntax, plist/XML parsing, `git diff --check`, exact-path review,
  secret/signing inspection, and generated-artifact inspection.

## Non-Goals

- Changing application runtime, project settings, environment schema, signing,
  credentials, or workflow behavior.
- Claiming Xcode build, simulator, device, location, or live venue execution.

## Work Completed

Pending implementation.

## Verification Completed

Pending implementation and verification.
