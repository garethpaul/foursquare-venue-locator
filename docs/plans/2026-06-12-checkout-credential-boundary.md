---
title: Checkout Credential Boundary
date: 2026-06-12
status: completed
execution: ci-security
---

## Context

The docs-only GitHub Actions job uses read-only repository permissions and a
pinned checkout action, but checkout still persists the workflow token in the
local Git configuration by default. The only later step runs `make check`, so
retaining that credential provides no benefit and expands the impact of an
unexpected script change.

## Goals

- Disable checkout credential persistence explicitly.
- Require exactly one pinned checkout step and one credential setting.
- Reject duplicate or relocated settings that could weaken the contract.
- Preserve the existing read-only permissions, Ubuntu runner, timeout, and
  docs-only `make check` behavior.

## Implementation

- Add `persist-credentials: false` to the checkout step.
- Replace the loose checkout pin assertion with a structural `awk` check.
- Update README, VISION, SECURITY, CHANGES, and the hosted-boundary plan.

## Verification

- `sh -n scripts/check-baseline.sh`
- `make lint`
- `make test`
- `make build`
- `make check`
- `git diff --check`
- Mutations for `true`, duplicate settings, and misplaced settings fail.
- Hosted GitHub Actions run

## Work Completed

- Disabled persisted checkout credentials on the single pinned checkout step.
- Replaced loose text matching with a structural workflow contract that rejects
  duplicate, true, and relocated credential settings.
- Preserved the read-only docs-only workflow boundary.

## Verification Completed

- All four Make gates, shell syntax, and `git diff --check` passed locally.
- Implementation push run `27392652005` and pull-request run `27392656600`
  passed at commit `3009a7d5c27c7355af64e2ac32b2abfaf4f1d375`.
- Post-merge push run `27392668931` and CodeQL run `27402320622` passed at
  default-branch merge commit `2c134f61b0ec165f3780a8bb376516f268e6c4cb`.
