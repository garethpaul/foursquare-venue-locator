---
title: Apple Private Key Artifact Guard
type: security
status: planned
date: 2026-06-13
---

# Apple Private Key Artifact Guard

## Summary

Extend the docs-only repository boundary so common Apple and TLS private-key
artifacts cannot be tracked accidentally.

## Priority

1. Keep App Store Connect, signing, and TLS private key files out of git.
2. Align ignore rules, tracked-file rejection, documentation, and static checks.
3. Preserve the existing docs-only and environment-template contracts.

## Requirements

- R1. `.gitignore` must exclude `*.p8`, `*.pfx`, `*.pem`, and `*.key` files.
- R2. The baseline must reject tracked files with those extensions regardless
  of directory or filename case where supported by the shell pattern.
- R3. The baseline must reject tracked PEM private-key markers even when a file
  uses an unexpected extension.
- R4. Existing `.env.example`, Apple signing, camera/location artifact,
  docs-only source, workflow, and checkout credential contracts must remain
  unchanged.
- R5. Static mutations must reject a missing ignore rule, a tracked private-key
  extension, and a tracked private-key marker.
- R6. README, SECURITY, VISION, CHANGES, and AGENTS must document the extended
  key boundary without claiming key rotation or historical secret remediation.

## Non-Goals

- Generating, rotating, revoking, validating, or installing signing keys.
- Rewriting git history or resolving provider-side credential state.
- Adding an Xcode project, app source, signing configuration, dependencies, or
  runtime behavior.
- Replacing GitHub secret scanning or repository rulesets.

## Implementation Units

### 1. Ignore And Tracked-File Guards

Files: `.gitignore`, `scripts/check-baseline.sh`

- Add exact ignore patterns for common private-key containers.
- Reject tracked key extensions and private-key block markers.

### 2. Repository Guidance

Files: `README.md`, `SECURITY.md`, `VISION.md`, `CHANGES.md`, `AGENTS.md`

- Record the local-only signing/key material boundary and its limitations.

## Verification Plan

- Run `make check`, `make lint`, `make test`, and `make build`.
- Remove one ignore rule, force-track a `.p8` fixture, and force-track a file
  containing a private-key marker; the baseline must reject each mutation.
- Run shell syntax, overview SVG parsing, executable-mode verification,
  `git diff --check`, and intended-path artifact and secret scans.
- Take bounded exact-head push, pull-request, and code-scanning snapshots after
  push; do not start a polling or watch loop.

## Work Completed

Pending implementation.

## Verification Completed

Pending implementation and verification.
