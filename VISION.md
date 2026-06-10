## Foursquare Venue Locator Vision

This document explains the current state and direction of the project.
Project overview and developer docs: [`README.md`](README.md)

Foursquare Venue Locator is currently a sparse public repository reserved for an
ARKit, CoreLocation, and Foursquare API venue-location experiment. The README now exists, and `scripts/check-baseline.sh` protects the current documentation and credential-safety baseline.

The only product context beyond the docs is the GitHub description:
"ARKit + CoreLocation + FoursquareAPI." There is no checked-in implementation,
app project, or dependency manifest yet.

No app source, Xcode project, dependency manifest, or executable runtime is
checked in yet. When implementation lands, it should update the baseline,
device-verification notes, and privacy/security guidance in the same change.

The goal is to keep the repository ready for a focused, credential-safe
location sample rather than accumulate unclear scaffolding.

The current focus is:

Priority:

- Establish project direction before adding code
- Keep Foursquare credentials and location data out of git
- Keep a non-secret .env.example available for future local Foursquare
  configuration
- Keep `.envrc` out of git because direnv-style local files can export real
  credentials
- Keep `*.xcconfig` out of git because local Xcode build settings can contain
  credentials, signing choices, or machine paths
- Keep `make lint`, `make test`, `make build`, and `make check` passing as the
  repository baseline evolves
- Document ARKit, CoreLocation, and physical-device requirements as soon as code exists
- Require camera and location purpose strings before future iOS app code lands
- Require baseline updates before future app source, project files, or
  dependency manifests land
- Keep Apple signing artifacts, provisioning profiles, archives, and result
  bundles out of git
- Keep Xcode user-state artifacts out of git
- Keep local location traces, simulator routes, and raw coordinate fixtures out
  of git until sanitized fixtures are explicitly documented
- Keep lint, test, build, and check targets available before app source exists
- Prefer a small verifiable prototype over broad app scaffolding
- Keep hosted checks aligned with the docs-only credential and privacy boundary

Next priorities:

- Add README setup and privacy notes before the first implementation
- Define the API configuration and location-permission model
- Keep local configuration examples limited to placeholder credentials
- Keep direnv and other local credential helper files ignored
- Keep local Xcode `*.xcconfig` build-setting files ignored unless a future app
  baseline documents sanitized checked-in configuration
- Add manual device verification steps for AR and location behavior
- Keep `NSLocationWhenInUseUsageDescription` and `NSCameraUsageDescription`
  guidance aligned with future app targets
- Keep `SECURITY.md` aligned with any credential or location workflow
- Keep signing artifacts and local Apple export outputs ignored as the app
  target takes shape
- Keep Xcode user-state artifacts ignored as the app target takes shape
- Keep local location traces ignored unless a future sample needs documented,
  synthetic route fixtures

Contribution rules:

- One PR = one focused setup, API, AR, or documentation topic.
- Do not commit real API credentials, signing files, or location traces.
- Do not commit raw simulator routes or local coordinate exports.
- Keep generated project files minimal until a working sample exists.
- Document physical-device requirements for AR/location behavior.

## Security And Privacy

Canonical security policy and reporting:

- [`SECURITY.md`](SECURITY.md)

Location and AR camera surfaces are sensitive. Future code must make permission
requests, API calls, and any data storage explicit and user-controlled.

## What We Will Not Merge (For Now)

- Hardcoded Foursquare credentials
- Background location tracking or camera data upload
- Broad scaffolding without README and verification notes
- Private location data or signing material

This list is a roadmap guardrail, not a permanent rule.
Strong user demand and strong technical rationale can change it.
