# Foursquare Venue iOS Privacy Keys

status: completed

## Context

The repository is a placeholder for a future ARKit, CoreLocation, and
Foursquare venue-location app. Before code lands, the docs should make the
required iOS camera and location purpose strings explicit.

## Objectives

- Document `NSLocationWhenInUseUsageDescription` as required for future
  CoreLocation behavior.
- Document `NSCameraUsageDescription` as required for future ARKit/camera
  behavior.
- Extend the static baseline so the privacy-key guidance stays visible.

## Verification

- `scripts/check-baseline.sh`
- `make check`
- `git diff --check`
