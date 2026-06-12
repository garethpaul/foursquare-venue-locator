# Hosted Boundary Checks

status: completed

## Context

The repository has a deterministic docs-only `make check` contract covering
credentials, Apple signing artifacts, location traces, Xcode user state, local
configuration, and accidental app scaffolding, but no hosted enforcement.

## Changes

- Added a least-privilege GitHub Actions workflow for pushes, pull requests,
  and manual runs.
- Pinned checkout by commit, disabled credential persistence, cancelled
  superseded runs, and bounded execution with a five-minute timeout.
- Extended the checker and project documentation to require hosted enforcement
  of the docs-only boundary.

## Verification

- `make check`
- Workflow YAML parse
- Hosted Ubuntu GitHub Actions run
