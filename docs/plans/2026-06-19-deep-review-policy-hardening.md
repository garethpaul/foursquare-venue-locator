---
title: Deep Review Policy Hardening
type: security
status: completed
date: 2026-06-19
execution: code
---

# Deep Review Policy Hardening

## Scope

Review stacked pull requests #3 through #8 and the complete documentation-only
mobile location/API baseline. Confirm whether runtime implementation exists and
test the repository's security claims with executable hostile fixtures.

## Findings

The repository contains no app source, Xcode project, dependency manifest,
Foursquare request code, CoreLocation callback, or UI implementation. Runtime
claims about credential redaction, URL encoding, location quality, response
bounds, stale callbacks, and UI ownership therefore cannot be proven here.

The existing shell gate was line-oriented and could be bypassed by tracked
symlinks, newline-bearing paths, several case variants, additional mobile
implementation languages and manifests, secret-bearing config containers, and
privileged workflow/token variants.

## Design

`scripts/check_repository_policy.py` owns repository-object invariants using
NUL-delimited Git index records. The existing shell checker continues to own
documentation and historical verification evidence. Every Make gate runs the
isolated hostile suite, the repository policy, and then the documentation gate.

## Verification

- Ten unittest methods cover 23 hostile/acceptance scenarios using temporary
  Git repositories.
- Coverage includes symlinks, executable modes, newline paths, private-key
  bytes, case variants, config containers, implementation artifacts,
  environment schema, and workflow privilege/token mutations.
- Root and external-directory Make gates, shell syntax, Python compilation,
  and `git diff --check` passed.
- Redacted Gitleaks scans found zero findings in the current tree and all 39
  commits. GitHub code-scanning, secret-scanning, and Dependabot reported zero
  open alerts.
- Exact implementation head `7447f5bc5ba0973560648dcb1f69725d417d06a7`
  passed pull-request Check run `27854302550`, push Check run `27854303480`,
  and CodeQL run `27854302759`.

## Runtime Boundary

The first mobile implementation must add focused tests for Foursquare
credential loading and redaction, URL/query encoding, HTTP status/schema/size
bounds, location freshness/accuracy/range, callback generation ownership, UI
thread/state ownership, permission failures, and physical-device/provider
behavior. This review intentionally does not claim those absent paths work.
