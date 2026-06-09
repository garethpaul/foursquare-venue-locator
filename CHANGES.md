# Changes

## 2026-06-09

- Added static guardrails and ignore rules for future Apple signing, archive,
  IPA export, and Xcode result artifacts.

## 2026-06-08

- Added a reproducible documentation-only baseline check for the current repository state.
- Documented that future Foursquare credentials and Apple local build settings must stay out of git.
- Added a placeholder-only `.env.example` so future Foursquare configuration
  has a safe local template.
- Added local artifact and credential ignore rules for future iOS/location work.
- Documented future iOS location and camera purpose-string requirements.
- Added a docs-only implementation boundary so app source or project files must
  update verification and privacy guidance when they land.
