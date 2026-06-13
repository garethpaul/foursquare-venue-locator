# AGENTS.md

## Repository purpose

`garethpaul/foursquare-venue-locator` is a documentation-only placeholder for a future ARKit, CoreLocation, and Foursquare API venue-location sample.

## Project structure

- `Makefile` - repository verification targets
- `scripts` - baseline checks and helper scripts
- `docs` - plans, notes, and generated README assets

## Development commands

- Install dependencies: no repository-specific install command is documented.
- Full baseline: `make check`
- If a command above skips because a platform toolchain is missing, verify on a machine with that SDK before claiming platform behavior is tested.

## Coding conventions

- Language mix noted in the README: no dominant source language detected.

## Testing guidance

- No dedicated test files were detected; treat `make check` as the minimum baseline.
- Start with the narrowest relevant test or Make target, then run `make check` before handing off if the change is not documentation-only.
- Keep README verification notes in sync when commands, fixtures, or supported toolchains change.

## PR / change guidance

- Keep diffs focused on the requested repository and avoid unrelated modernization or formatting churn.
- Preserve public APIs, sample behavior, file formats, and documented environment variables unless the task explicitly changes them.
- Update tests, README notes, or docs/plans when behavior, security posture, or validation commands change.
- Call out skipped platform validation, legacy toolchain assumptions, and any risky files touched in the final summary.

## Safety and gotchas

- `.env.example` contains placeholder values for future local Foursquare configuration. Copy it to `.env` for local experiments and keep real values out of git.
- Local direnv files such as `.envrc` are ignored because they can export real Foursquare credentials or machine-specific settings.
- Future Foursquare settings should use local-only names such as `FOURSQUARE_CLIENT_ID` and `FOURSQUARE_CLIENT_SECRET`; do not commit real values, generated config, or API query strings that include credentials.
- Future iOS app targets should include clear `NSLocationWhenInUseUsageDescription` and `NSCameraUsageDescription` purpose strings before any ARKit, CoreLocation, or camera code is added.
- Future implementation changes should add device verification notes and dependency manifests in the same change that introduces app source.
- Future Apple signing artifacts, provisioning profiles, archives, IPA exports, and Xcode result bundles are ignored and must stay out of git.
- App Store Connect, signing, and TLS private key files (`.p8`, `.pfx`, `.pem`,
  and `.key`) and private-key block material must stay out of git.

## Agent workflow

1. Inspect the README, Makefile, manifests, and the files directly related to the request.
2. Make the smallest source or docs change that satisfies the task; avoid generated, vendored, or local-environment files unless required.
3. Run the narrowest useful validation first, then `make check` or the documented package/platform gate when available.
4. If a required SDK, service credential, or external runtime is unavailable, record the skipped command and why.
5. Summarize changed files, commands run, and remaining risks or follow-up validation.
