## Foursquare Venue Locator Vision

Foursquare Venue Locator is currently a sparse public repository reserved for an
ARKit, CoreLocation, and Foursquare API venue-location experiment.

The only project context beyond security policy is the GitHub description:
"ARKit + CoreLocation + FoursquareAPI." There is no checked-in implementation
or README yet.

The goal is to keep the repository ready for a focused, credential-safe
location sample rather than accumulate unclear scaffolding.

The current focus is:

Priority:

- Establish project direction before adding code
- Keep Foursquare credentials and location data out of git
- Document ARKit, CoreLocation, and device requirements as soon as code exists
- Prefer a small verifiable prototype over broad app scaffolding

Next priorities:

- Add README setup and privacy notes before the first implementation
- Define the API configuration and location-permission model
- Add manual device verification steps for AR and location behavior
- Keep `SECURITY.md` aligned with any credential or location workflow

Contribution rules:

- One PR = one focused setup, API, AR, or documentation topic.
- Do not commit real API credentials, signing files, or location traces.
- Keep generated project files minimal until a working sample exists.
- Document physical-device requirements for AR/location behavior.

## Security And Privacy

Location and AR camera surfaces are sensitive. Future code must make permission
requests, API calls, and any data storage explicit and user-controlled.

## What We Will Not Merge (For Now)

- Hardcoded Foursquare credentials
- Background location tracking or camera data upload
- Broad scaffolding without README and verification notes
- Private location data or signing material

This list is a roadmap guardrail, not a permanent rule.
Strong user demand and strong technical rationale can change it.
