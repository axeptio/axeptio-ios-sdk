# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Nature

This is a **distribution-only repository** for the Axeptio iOS SDK. It contains a pre-compiled binary framework (`AxeptioSDK.xcframework`) — no source code is included here.

## Distribution Mechanisms

- **Swift Package Manager**: `Package.swift` wraps the binary xcframework
- **CocoaPods**: `AxeptioIOSSDK.podspec` references the xcframework

Minimum deployment target: **iOS 15.0**, Swift 5.6+.

## Releasing a New Version

Releases are driven by git tags. The CI/CD pipeline validates the podspec (`pod lib lint --allow-warnings`), publishes to CocoaPods trunk, and opens update PRs on dependent repositories.

## SDK Public API

**Initialization:**
```swift
Axeptio.shared.initialize(
    targetService: .publisherTcf,
    clientId: "<clientId>",
    cookiesVersion: "<version>",
    widgetType: .production          // .production | .staging | .pr
)
```

**Key methods on `Axeptio.shared`:**
- `showConsentScreen()` — displays the consent widget
- `getRemainingDaysForConsent()` — returns days until consent expires

**Notable configuration options:**
- `cookiesDurationDays` — consent lifetime (default 190 days)
- `shouldUpdateCookiesDuration` — auto-reset duration on new consent
- `token` — optional authentication token

**Consent standards supported:** IAB TCF v1, TCF v2, Google Consent Mode v2.

**Privacy:** SDK accesses `UserDefaults` (declared in `PrivacyInfo.xcprivacy`) and collects `ProductInteraction` analytics data (non-tracking).

## Versioning

Version is sourced from the git tag (`LIB_VERSION` env var in CI). The podspec defaults to `1.0.0` locally if the env var is absent. Always tag before publishing.
