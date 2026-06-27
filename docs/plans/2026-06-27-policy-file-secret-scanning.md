---
title: Policy File Secret Scanning
type: security
status: completed
date: 2026-06-27
execution: code
---

# Policy File Secret Scanning

## Context

`reject_sensitive_content` skipped the shell baseline, Python policy checker,
and hostile test module before inspecting their bytes. Those files legitimately
describe credential and private-key markers, but a whole-file exemption also
allowed real matching material to be tracked there without rejection.

## Design

1. Remove the blanket enforcement-file exemption.
2. Construct legitimate hostile values and placeholder assignments from
   adjacent fragments so the repository source does not contain a live marker.
3. Keep the hostile repositories' written bytes unchanged.
4. Add one mutation for each formerly exempt path.

Narrow marker construction was chosen over path-specific replacement or line
allowlists because every tracked file should cross the same content boundary.

## Verification

- The focused regression failed all three subtests before implementation.
- The focused regression passed after removing the exemption.
- `make check` passed 11 unittest methods, the NUL-safe policy inspection, and
  the documentation baseline.
- `git diff --check` passed.

## Scope

This change detects the existing private-key and raw provider credential
signatures in every tracked regular file. It does not claim exhaustive secret
detection for every provider or encoded/encrypted payload.
