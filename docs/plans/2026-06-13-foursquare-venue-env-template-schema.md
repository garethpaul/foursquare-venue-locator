---
title: Foursquare Venue Environment Template Schema
date: 2026-06-13
status: in_progress
execution: code
---

## Context

The docs-only baseline requires two safe Foursquare placeholders in
`.env.example`, but the current check does not reject extra assignments,
duplicate keys, shell execution syntax, or executable file mode. The template
can therefore drift beyond the narrow credential schema while still passing.

## Goals

- Keep `.env.example` limited to comments, blank lines, and exactly one
  placeholder assignment for each documented Foursquare credential.
- Reject additional variables, duplicate keys, `export`, command expansion,
  shell separators, and executable mode.
- Preserve the existing ignored local credential files and repository-wide
  raw-secret scan.
- Document the exact template boundary for future implementation work.

## Implementation

- Parse `.env.example` as a constrained line-oriented schema in the baseline
  checker.
- Verify the tracked file is regular, non-executable mode `100644`.
- Extend repository guidance and completed-plan evidence requirements.

## Verification Plan

- Run shell syntax, all four Make gates, SVG/XML parsing, `git diff --check`,
  and an intended-file secret scan.
- Add an extra assignment, add command substitution, duplicate a key, and make
  the file executable; each hostile mutation must fail.
- Take one bounded exact-head pull-request and CodeQL snapshot after push; do
  not poll.
