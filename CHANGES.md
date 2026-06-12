# Changes

## 2026-06-12

- Disabled checkout credential persistence in the docs-only GitHub Actions job.
- Added a structural check that rejects duplicate, misplaced, or weakened
  checkout credential settings.

## 2026-06-10

- Added ignore and tracked-file guards for future local AR camera captures and
  recordings that may contain sensitive visual or location metadata.
- Added a pinned, least-privilege GitHub Actions workflow that enforces the
  docs-only credential, privacy, artifact, and scaffold boundary.

## 2026-06-09

- Added baseline coverage for local `*.xcconfig` Xcode build-setting files.
- Added ignore and baseline coverage for local `.envrc` credential helper
  files.
- Added explicit ignore and baseline coverage for Xcode user-state files and
  workspace user data.
- Added `make lint`, `make test`, and `make build` aliases so local verification
  has the expected pre-push gate targets in addition to `make check`.
- Added static guardrails and ignore rules for future Apple signing, archive,
  IPA export, and Xcode result artifacts.
- Added static guardrails and ignore rules for local location traces, simulator
  routes, and raw coordinate fixtures.

## 2026-06-08

- Added a reproducible documentation-only baseline check for the current repository state.
- Documented that future Foursquare credentials and Apple local build settings must stay out of git.
- Added a placeholder-only `.env.example` so future Foursquare configuration
  has a safe local template.
- Added local artifact and credential ignore rules for future iOS/location work.
- Documented future iOS location and camera purpose-string requirements.
- Added a docs-only implementation boundary so app source or project files must
  update verification and privacy guidance when they land.
