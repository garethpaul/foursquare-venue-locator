# Changes

## 2026-06-27T00:31:00Z - P1 - Scan enforcement files for secrets

### Summary
Removed a content-scanning trust gap that allowed credential or private-key
material to be tracked inside the policy checker, shell baseline, or hostile
test module.

### Work completed
- Removed the blanket policy-file exemption from tracked-content inspection.
- Made legitimate credential-marker fixtures and shell patterns self-safe
  without weakening the values written into hostile repositories.
- Added three regressions covering each formerly exempt enforcement path.

### Threads
- None; no open pull requests or issues existed, and stale policy branches were
  inspected before implementation.

### Files changed
- `scripts/check_repository_policy.py` — scan every tracked regular file.
- `scripts/check-baseline.sh` — retain the raw credential check without a
  self-matching literal.
- `tests/test_repository_policy.py` — exercise all three former bypass paths.
- `README.md` — document the no-exemption content boundary.
- `docs/plans/2026-06-27-policy-file-secret-scanning.md` — record design and
  verification.

### Validation
- Focused regression before implementation — failed all three formerly exempt
  paths because no `PolicyError` was raised.
- Focused regression after implementation — passed.
- `make check` — passed 11 unittest methods, repository policy, and baseline.
- `git diff --check` — passed.

### Bugs / findings
- The policy's strongest enforcement files were trusted wholesale, so a real
  provider token or private-key block placed there bypassed content scanning.
- Existing stale branches contained earlier policy hardening but not this fix.

### Blockers
- None.

### Next action
- Require the exact pull-request head to pass hosted Check and CodeQL before
  merge, then verify the resulting `master` workflows.

## 2026-06-19

- Added a NUL-safe tracked-file policy that rejects symlinks, unexpected modes,
  case/path variants, implementation surfaces, secret-bearing config
  containers, and oversized blobs.
- Added isolated hostile repository tests and made every Make gate execute
  them before the documentation-evidence checks.
- Hardened the workflow boundary against write permissions, secret/token
  expressions, `pull_request_target`, unpinned checkout, and credential
  persistence variants.

## 2026-06-18

- Made the docs-only Swift, Xcode, CocoaPods, and SwiftPM implementation
  artifact boundary case-insensitive.

## 2026-06-13

- Made docs-only verification independent of the caller's working directory by
  resolving the baseline checker from the loaded Makefile.
- Made tracked Apple signing artifact rejection case-insensitive.
- Ignored and rejected common App Store Connect, signing, and TLS private key
  containers plus tracked private-key block material.
- Added static mutation coverage for ignore rules, tracked extensions, and key
  markers.
- Enforced an exact non-executable two-key schema for the placeholder-only
  Foursquare environment template.

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
