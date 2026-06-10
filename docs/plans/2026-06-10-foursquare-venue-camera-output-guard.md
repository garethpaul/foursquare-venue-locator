# Foursquare Venue Camera Output Guard

status: completed

## Context

The docs-only baseline excludes local location traces, credentials, signing
artifacts, and Xcode user state. It does not yet reserve local-only paths for
future AR camera captures or recordings, which can contain people, private
spaces, and embedded location metadata.

## Priority

Camera output is a privacy-sensitive artifact expected from the planned app.
Defining the boundary before source lands prevents accidental commits without
blocking intentionally reviewed app assets elsewhere in the repository.

## Implementation

- Ignore dedicated `camera-captures` and `camera-recordings` directories in
  common lowercase and Xcode-style capitalized forms.
- Reject tracked files under those directories in the docs-only baseline.
- Document that intentional sanitized media fixtures require an explicit
  baseline update and metadata review.
- Preserve existing location-trace, signing, credential, and scaffold guards.

## Verification

- `make check`
- `make lint`
- `make test`
- `make build`
- `git diff --check`
- Mutations removing an ignore rule or tracked-path guard must fail.
- Hosted docs-only boundary workflow.
