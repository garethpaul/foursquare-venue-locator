# Foursquare Venue Locator Baseline Plan

status: completed

## Context

`foursquare-venue-locator` is currently a documentation-only repository reserved for an ARKit, CoreLocation, and Foursquare API sample. It has no checked-in app project, dependency manifest, or executable test suite.

## Objectives

- Preserve the repository as a credential-safe placeholder for a future location sample.
- Add a reproducible local verification command that validates the documentation and sensitive-surface guardrails already present.
- Align README and VISION language with the current repository contents.
- Keep local machine files, credentials, and future Apple build settings out of git.

## Work Items

1. Add a `make check` baseline that runs a static repository validation script.
2. Add ignore rules for local secrets, machine files, and future Xcode-local configuration.
3. Update documentation to describe the new verification command and future credential expectations.
4. Record the completed baseline in `CHANGES.md`.

## Verification

- `make check`
- `git diff --check`
