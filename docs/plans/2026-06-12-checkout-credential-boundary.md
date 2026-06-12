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
