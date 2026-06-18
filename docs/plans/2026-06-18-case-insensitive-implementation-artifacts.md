---
title: Case-Insensitive Implementation Artifact Boundary
type: testing
status: completed
date: 2026-06-18
execution: code
---

# Case-Insensitive Implementation Artifact Boundary

## Context

The repository intentionally contains documentation, configuration templates,
and static maintenance checks rather than an application. Its baseline rejects
tracked Swift source, Xcode projects/workspaces, CocoaPods manifests, and Swift
package manifests before the implementation boundary is deliberately updated.
That check is case-sensitive, so names such as `Demo.SWIFT` or
`App.XCODEPROJ/project.pbxproj` bypass it on Linux even though they represent the
same artifact classes on common case-insensitive macOS filesystems.

## Prioritized Engineering Tasks

1. **P0: Close the case-variant bypass.** Normalize tracked paths before testing
   the docs-only implementation artifact boundary.
2. **P1: Preserve exact scope.** Continue rejecting Swift, Xcode, Podfile, and
   Package.swift artifacts without broadening the rule to unrelated files.
3. **P1: Prove the boundary.** Add isolated tracked-path mutations for ordinary
   and mixed-case implementation artifacts.
4. **P2: Keep evidence durable.** Synchronize guidance and require truthful
   completed local and hosted verification.

## Requirements

- Compare tracked implementation paths case-insensitively.
- Reject `.swift` files, `.xcodeproj` and `.xcworkspace` contents, `Podfile`, and
  `Package.swift` regardless of filename case.
- Preserve the current error path and docs-only repository classification.
- Preserve all credential, signing, private-key, local configuration, location
  trace, camera output, CI, and external-directory Make boundaries.
- Add mutation-sensitive contracts and exact verification evidence.

## Scope Boundaries

- Do not add application source, Xcode metadata, dependency manifests, or a
  generated scaffold.
- Do not ignore implementation artifacts; their arrival must still require an
  explicit baseline and documentation update.
- Do not change the environment template, workflow permissions, or artifact
  guardrails outside this path-comparison defect.
- Do not merge or close this stacked pull request or its predecessors without
  explicit authorization.

## Implementation Units

### U1. Case-insensitive path contract

Files:

- `scripts/check-baseline.sh`

Normalize `git ls-files` output to lowercase before applying the existing
implementation artifact patterns, while retaining path-boundary precision.

### U2. Guidance and evidence

Files:

- `README.md`
- `SECURITY.md`
- `VISION.md`
- `CHANGES.md`
- `AGENTS.md`
- `docs/plans/2026-06-18-case-insensitive-implementation-artifacts.md`

Document the case-insensitive portability boundary and actual validation.

## Test Scenarios

- Reject an ordinary tracked `.swift` file.
- Reject a mixed-case tracked `.SWIFT` file.
- Reject mixed-case `.XCODEPROJ` and `.XCWORKSPACE` contents.
- Reject mixed-case `PODFILE` and `PACKAGE.SWIFT` manifests.
- Continue accepting similarly named non-artifacts such as `Podfile.md` and
  `Package.swift.md`.
- Reject mutations that remove lowercase normalization, weaken a path pattern,
  remove guidance, or reopen completed evidence.

## Verification

- Run shell syntax and every Make alias from repository and external working
  directories.
- Run isolated tracked-file mutations for each protected artifact class and
  nearby non-artifact names.
- Audit the exact diff, modes, generated artifacts, conflict markers, and
  credential-shaped additions.
- Require one bounded exact-head push, pull-request, and security-alert snapshot.

## Risks

- Lowercasing paths could create false positives if patterns are not precisely
  anchored; nearby non-artifact mutation cases protect that boundary.
- The repository remains intentionally non-executable, so validation proves
  maintenance policy rather than application runtime behavior.

## Verification Completed

The tracked-path implementation boundary now lowercases `git ls-files` output
before matching the existing Swift, Xcode, CocoaPods, and SwiftPM artifact
classes. The patterns remain path-anchored so similarly named documentation
files are outside the rejection boundary.

Repository-root and external-directory Make gates passed for `check`, `lint`,
`test`, and `build`. Six isolated tracked implementation artifacts were
rejected across lowercase and mixed-case Swift, Xcode project/workspace,
CocoaPods, and SwiftPM names. Two nearby documentation filenames remained
accepted. Four additional mutations removing normalization, weakening the Xcode
pattern, removing guidance, or reopening plan status were rejected.

Ten isolated mutations were rejected in total, while both anchored nearby
documentation-name cases remained accepted.
Both exact-head push and pull-request checks passed at
implementation head `b8e52585610bc37998c453e4b1ce0ac22f2e578c`: push run `27740007858` and
pull-request run `27740016488` completed the full baseline successfully.

No application source or dependency manifest was added. The repository remains
documentation-only, and no credentials or private configuration were required.
