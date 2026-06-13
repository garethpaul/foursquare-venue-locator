---
title: Case Insensitive Signing Artifact Guard
type: security
status: planned
date: 2026-06-13
---

# Case Insensitive Signing Artifact Guard

## Summary

Reject tracked Apple signing, archive, and result artifacts regardless of
filename-extension case.

## Requirements

- R1. Reject lowercase, uppercase, and mixed-case `.mobileprovision`, `.p12`,
  `.cer`, `.ipa`, `.xcarchive`, and `.xcresult` tracked paths.
- R2. Keep existing private-key marker and `.p8`/`.pfx`/`.pem`/`.key` guards.
- R3. Preserve the docs-only, environment-template, workflow, and other local
  artifact policies.
- R4. Add alternate-index mutations for uppercase and mixed-case artifacts.
- R5. Update maintained docs without claiming history cleanup or revocation.

## Verification Plan

- Run all four Make gates and shell/diff/SVG checks.
- Reject lowercase, uppercase, mixed-case, stale-plan, and missing-evidence
  mutations using isolated alternate Git indexes where applicable.
- Take one bounded exact-head push/PR/code-scanning snapshot after push.

## Non-Goals

- Rewriting history, rotating credentials, or changing repository rulesets.
- Adding application source, an Xcode project, dependencies, or runtime code.
