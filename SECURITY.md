# Security Policy

## Supported Versions

The supported security scope for `foursquare-venue-locator` is the current default branch, `master`. Older commits, tags, branches, forks, demos, and generated artifacts are not actively supported unless the repository explicitly marks them as maintained.

Project summary: ARKit + CoreLocation + FoursquareAPI

## Reporting a Vulnerability

Please report suspected vulnerabilities through GitHub's private vulnerability reporting or by opening a draft GitHub Security Advisory for `garethpaul/foursquare-venue-locator` when that option is available. If GitHub does not show a private reporting option for this repository, contact the repository owner through GitHub and avoid posting exploit details publicly until the issue can be assessed.

Do not open a public issue that includes exploit code, secrets, personal data, or detailed reproduction steps for an unpatched vulnerability.

## What to Include

Helpful reports include:

- the affected file, endpoint, permission, dependency, or workflow
- a concise impact statement explaining what an attacker could do
- reproduction steps using test data and accounts you control
- the branch, commit SHA, platform version, device, runtime, or dependency versions used
- logs, screenshots, or proof-of-concept snippets that demonstrate impact without exposing private data

## Project Security Posture

- This repository appears to be a public sample, documentation, or utility project. The active security scope is the code and documentation on the default branch.
- The repository scan did not identify production authentication, payment, or secret-management code. Treat the project as public sample code unless future changes add sensitive surfaces.
- No primary dependency manifest was detected in the repository root. If dependencies are added later, include a manifest and prefer reproducible installation instructions.
- `.env.example` is a placeholder-only template with an exact two-key schema
  and no shell execution syntax. Real Foursquare credentials belong in the
  ignored local `.env` file and must not be committed.
- `.envrc` is treated as a local credential helper file and must not be
  committed.
- `*.xcconfig` files are treated as local Xcode build settings and must not be
  committed unless a future app baseline documents sanitized checked-in
  configuration.
- Apple signing artifacts, provisioning profiles, archives, IPA exports, and
  Xcode result bundles are local outputs and must not be committed, regardless
  of filename-extension case.
- App Store Connect, signing, and TLS private key containers (`.p8`, `.pfx`,
  `.pem`, and `.key`) and private-key block material must not be committed.
- Xcode user-state files and workspace user data are local outputs and must not
  be committed.
- Local GPX, GeoJSON, KML, and location traces can expose precise coordinates
  and movement patterns; keep them out of git unless a future sanitized fixture
  policy is added.
- Local AR camera captures and recordings can expose people, private spaces,
  and embedded location metadata; keep them out of git unless a sanitized
  fixture policy is explicitly reviewed.
- Future ARKit, CoreLocation, and camera code should document permission prompts,
  physical-device verification, credential configuration, and whether any
  location or camera data is persisted or transmitted.
- Tracked Swift, Xcode, CocoaPods, and SwiftPM implementation artifacts are
  rejected case-insensitively while the repository remains documentation-only.


## Dependency and Supply Chain Security

GitHub Actions runs the docs-only credential, signing, location-trace, and
scaffolding guards with read-only repository permissions and no persisted
checkout credentials before changes land.

Dependency updates should come from trusted package managers and should keep lockfiles in sync when lockfiles exist. Do not commit credentials, private keys, tokens, generated secrets, or machine-local configuration. If a vulnerability depends on a compromised package, typosquatting risk, insecure transitive dependency, or unsafe build step, include the package name, affected version, and the path through which it is used.

## Safe Research Guidelines

Good-faith research is welcome when it stays within these boundaries:

- use only accounts, devices, data, and infrastructure that you own or have explicit permission to test
- avoid destructive actions, persistence, spam, phishing, social engineering, or denial-of-service testing
- minimize access to personal data and stop testing immediately if private data is exposed
- do not exfiltrate secrets or third-party data; report the minimum evidence needed to verify impact
- keep vulnerability details confidential until the maintainer has assessed the report

## Maintainer Response

The maintainer will review complete reports as availability allows, prioritize issues by exploitability and impact, and coordinate a fix or mitigation when the affected code is still maintained. For sample, archived, or educational repositories, the likely remediation may be documentation, dependency updates, or clearly marking unsupported code rather than a production-style patch release.
