<img src="https://github.com/user-attachments/assets/5799ac86-5d77-4a9e-9bdf-36d40881a449" width="600" height="300"/>

# Axeptio SDK


![License](https://img.shields.io/badge/license-Apache%202.0-blue) ![iOS version >= 15](https://img.shields.io/badge/iOS%20version-%3E%3D%2015-green) ![Platform](https://img.shields.io/badge/platform-iOS-blue) [![Axeptio SDK Version](https://img.shields.io/github/v/release/axeptio/axeptio-ios-sdk)](https://github.com/axeptio/axeptio-ios-sdk/releases) [![Swift Integration](https://img.shields.io/badge/Integration-Swift%20%26%20SwiftUI-orange)](https://github.com/axeptio/sample-app-ios) ![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen)

> **2.2.0 is out** — includes a **breaking change**: Objective-C support has been dropped.
> The SDK is now Swift-only. See the [2.2.0 release notes](https://github.com/axeptio/axeptio-ios-sdk/releases/tag/2.2.0).

> **⚠️ CocoaPods sunset notice**
>
> The CocoaPods Specs Repo (trunk) [goes read-only on **2026-12-02**](https://blog.cocoapods.org/CocoaPods-Specs-Repo/).
> After that date, no new versions of the Axeptio SDK can be published to the trunk.
>
> **Versions up to and including the last one published before that date will remain installable** —
> existing `pod 'AxeptioIOSSDK', '~> 2.2'` integrations keep working.
>
> **For new versions after Dec 2026**, use one of:
>
> 1. **Switch to Swift Package Manager** (recommended — already supported):
>    ```swift
>    .package(url: "https://github.com/axeptio/axeptio-ios-sdk.git", from: "2.2.0")
>    ```
>
> 2. **Pin a specific tag in your `Podfile`** (no Specs Repo needed):
>    ```ruby
>    pod 'AxeptioIOSSDK',
>      :git => 'https://github.com/axeptio/axeptio-ios-sdk.git',
>      :tag => '2.2.0'
>    ```
>    You'll need to bump `:tag` manually for each release. Loses `pod search` and `~>` semver matching.
>
> We recommend planning the SPM migration well before the deadline.

The Axeptio SDK for iOS allows applications to seamlessly ask for and collect user consent for data processing in compliance with privacy regulations.

## Table of Contents
1. [Supported Standards](#supported-standards)
2. [Implementation](#implementation)
3. [Migration Guide](#migration-guide)
4. [Features](#features)
5. [License](#license)
<br><br><br>
## Supported Standards
The **Axeptio CMP SDK for iOS** supports the following consent management frameworks and standards:

* IAB TCF v1 (Transparency and Consent Framework)
* IAB TCF v2 (Transparency and Consent Framework)
* Google Consent Mode v2
<br><br><br>
## Implementation

For detailed instructions on how to implement and configure the Axeptio SDK in your iOS application, please refer to the official [SDK implementation guide](https://github.com/axeptio/sample-app-ios).
<br><br><br>
## Migration Guide

### 2.0.x → 2.1.x

**SDK minimum deployment target remains iOS 15.** If you received a linker error after upgrading, the cause is an API change — not an iOS version requirement.

#### Breaking change: `widgetType` is now a required parameter in `initialize()`

The `initialize()` method signature changed in 2.1.0. The `widgetType` parameter is now required with no default value.

**Before (2.0.x):**

```swift
Axeptio.shared.initialize(
    targetService: .brands,
    clientId: "your-client-id",
    cookiesVersion: "your-cookies-version"
)
```

**After (2.1.x):**

```swift
Axeptio.shared.initialize(
    targetService: .brands,
    clientId: "your-client-id",
    cookiesVersion: "your-cookies-version",
    widgetType: .production   // ← add this
)
```

Use `.production` for live apps, `.staging` for testing against your staging environment.

Optional settings (token, PR targeting, cookie duration) are now configured via a separate `configure()` call:

```swift
// Optional — call before initialize() if needed
Axeptio.shared.configure(
    token: nil,
    widgetPR: nil,
    cookiesDurationDays: 190,
    shouldUpdateCookiesDuration: false
)
```

> **Note:** Changing the Xcode deployment target to iOS 18 is **not** the fix. The SDK supports iOS 15+. The fix is adding `widgetType: .production` to your `initialize()` call.
<br><br><br>
## Features
- Easy integration with your iOS application.

- Supports the latest consent management standards.

- Provides a user-friendly interface for obtaining consent.

- Fully customizable to meet specific application requirements.
<br><br><br>
## License
The **Axeptio SDK** is available under the **MIT License**. For more details, please refer to the [License](https://github.com/axeptio/axeptio-ios-sdk/blob/Update-READme/LICENSE) file.
