---
title: Location-Independent Venue Locator Verification
type: reliability
date: 2026-06-13
status: completed
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

- Derived the repository root from the loaded Makefile and invoked the static
  checker through that absolute path.
- Extended the baseline with rooted-Makefile, completed-plan, external-run, and
  synchronized-guidance contracts.
- Preserved environment-template, credential, private-key, signing-artifact,
  scaffold, privacy, workflow, and generated-artifact boundaries unchanged.

## Verification Completed

- `make check`, `make lint`, `make test`, and `make build` passed at repository
  root and from /tmp through the absolute Makefile path.
- Five isolated hostile root-derivation, checker-path, documentation,
  plan-status, and verification-evidence mutations were rejected.
- Shell syntax, `git diff --check`, exact-path review, added-line secret/signing
  inspection, and generated-artifact inspection passed.
- No application runtime exists in the repository; Xcode, simulator, device,
  location, and live venue behavior are not claimed.
