---
title: Foursquare Venue Envrc Guard
date: 2026-06-09
status: completed
execution: docs
---

## Context

The repository already keeps `.env` files ignored and provides a placeholder
`.env.example` for future Foursquare configuration. Developers may also use
direnv or similar tooling, where `.envrc` can export real API credentials or
machine-specific settings.

## Goals

- Ignore `.envrc` as a local credential helper file.
- Fail the docs-only baseline if `.envrc` is tracked.
- Document the direnv boundary in README, SECURITY, and VISION.
- Preserve the existing placeholder-only `.env.example` contract.

## Implementation

- Added `.envrc` to `.gitignore`.
- Added tracked-file and ignore-rule checks to `scripts/check-baseline.sh`.
- Updated README, SECURITY, VISION, and CHANGES.

## Verification

- `sh -n scripts/check-baseline.sh`
- `scripts/check-baseline.sh`
- `make lint`
- `make test`
- `make build`
- `make check`
- `git diff --check`
