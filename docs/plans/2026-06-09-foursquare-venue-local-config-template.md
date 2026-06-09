# Foursquare Venue Local Config Template

status: completed

## Context

The repository has no app source yet, but future Foursquare work will require
local credentials. The ignore rules already keep `.env` out of git and allow a
tracked `.env.example`, but no safe template existed.

## Objectives

- Add a checked-in `.env.example` with placeholder-only Foursquare credential
  names.
- Keep real credentials in ignored local files.
- Extend the static baseline so the template and docs remain aligned.

## Verification

- `scripts/check-baseline.sh`
- `make check`
- `git diff --check`
