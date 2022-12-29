# Introduction

User consent is not limited to the web, but applies to all platforms that collect user data. This includes mobile devices.

# Current Release : AxeptioSDK @0.4.1

## Author

Axeptio

## License

AxeptioSDK is available under the MIT license. See the LICENSE file for more information.

## Requirements

Minimum iOS version: **12.x**

Better with xCode **14.x.x**

## Improvments

####  **0.4.1**
- iOS 12
- xCode 14
- test app in 0.4.2
- fixes
  - on Info layout , switch are no more shown as this is only to tell user which cookies are mandatory
  - improve touchable items size to provide better accessibility( “touchability”) and a better readability
  - this stand for texts and icons, and buttons ,
  - vendrors description an icons
  - buttons icons
  - buttons texts can not fit on two lines as on its android counter part sdk


####  **0.4.0**
 - iOS 12
 - xCode 14
 - synchronise version number with android sdk version 
 - fixes
    - layout management , info layout was not managed
    - add a rerere api to reinitialise the SDK with a new Client ID and version project id
    - update test app accordingly to demo the  rerere feature swapping in between two client id and version (hardcoded))

####  **0.3.6**
 - iOS 12
 - xCode 14
 - fixes
 	 - remove unnecessary files that prevented publishing something on the App Store
	the signing process failed to sign them.
	these files were added by mistake 

####  **0.3.4**
 - iOS 12
 - xCode 13
 - fixes
 	- [UX Improvements] - reduce left and right horizontal insets to provide a better width
	- [fixes AXE-1601] - in cookie, vendor, the domain turns out to be optional and not mandatory

####  **0.3.3**
- iOS 12 
- xCode 12
- fixes 
	- [AXE-665] fix crash when one or more H, S B values are missing in the paintT ransfrom JSON Item
	
#### **0.3.1**
- iOS 11
- xCode 11




# Installation

### 1. If you haven’t already, install the latest version of [CocoaPods](https://guides.cocoapods.org/using/getting-started.html#installation).

### 2. If you don’t have an existing Podfile, create a new one by running the command:

```bash
pod Init
```

### 3. Add `pod 'AxeptioSDK'` to your Podfile:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '12.0'
use_frameworks!

target 'MyApp' do
  pod 'AxeptioSDK'
end

post_install do |installer|
	installer.pods_project.targets.each do |target|
		target.build_configurations.each do |config|
			config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
		end
	end
end
```

### 4. Run the following command:

```bash
pod install
```

### 5. In the future, to update the SDK to its latest version, run the command:

```bash
pod update AxeptioSDK
```

```bash
pod update
```

### 6. Cleaning up your project from everything related to CocoaPods
```bash
pod deintegrate
```

##### Remark
- by simply deleting the files (Podfile, Podfile.lock, xcworkspace file (package folder in fact) and Pods Folder, you do not delete the change that was made in your xCode project file settings

# Getting started

## Swift

In the main controller of your applmication, import the `AxeptioSDK` module, initialize the SDK by calling the `initialize` method providing a `clientId` and a `version`. Once initialization is complete, you can make the widget appear by calling the `showConsentController` method.

```swift
import UIKit
import AxeptioSDK

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set a custom token
        // Axeptio.shared.token = "auto-generated-token-xxx"

        Axeptio.shared.initialize(clientId: "<Client ID>", version: "<Version>") { error in
	    // Handle error
	    // You could try to initialize again after some delay for example
            Axeptio.shared.showConsentController(in: self) { error in
                // User has made his choices
		// We can now enable or disable the collection of metrics of the analytics library
                if Axeptio.shared.getUserConsent(forVendor: "<Vendor name>") ?? false {
                    // Disable collection
                } else {
                    // Enable collection
                }
            }
        }
    }
}
```

If your application supports multiple languages, you have probably created a different version for each of them in the Axeptio [administration web page] (https://admin.axeptio.eu). In this case you can store the version for each language in the `Localizable.strings` file and use `NSLocalizedString` to get the appropriate version for the user.

## Objective-C

```objective-c
#import "ViewController.h"
#import <AxeptioSDK/AxeptioSDK-Swift.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Set a custom token
    // [Axeptio setToken:@"auto-generated-token-xxx"];

    [Axeptio initializeWithClientId:@"<Client ID>" version:@"<Version>" completionHandler:^(NSError *error) {
        // Handle error
        // You could try to initialize again after some delay for example
        [Axeptio showConsentControllerWithInitialStepIndex:0 onlyFirstTime:TRUE in:self animated:YES completionHandler:^(NSError *error) {
            // User has made his choices
            // We can now enable or disable the collection of metrics of the analytics library
            if ([Axeptio getUserConsentForVendor:@"<Vendor name>"]) {
                // Disable collection
            } else {
                // Enable collection
            }
        }];
    }];
}


@end
```

## API Reference

### Apple Tracking User Data permission
- https://developer.apple.com/app-store/user-privacy-and-data-use/


### Properties

#### token

The `token` property can be used to set a custom token. By default, a random identifier is set.

This property is particularly useful for apps using webviews. By opening the webview while passing the token in the `axeptio_token` querystring parameter, the consent previously given in the app will be reused on the website if it uses the web SDK.

### Methods

#### initialize

The `initialize` function initializes the SDK by fetching the configuration and calling the completion handler when finished. 

If this fails, because of the network for example, it is possible to call the `initialize` function again, unless the error is Already Initialized.

If you need to reset the Axeptio SDK for a different project id for the same client id or change both you should call the revere function

```swift
func initialize(clientId: String, version: String, completionHandler: @escaping (Error?) -> Void)
```

#### rerere (reset)

The `rerere` function resets the SDK by fetching the configuration and calling the completion handler when finished in the same way as `initialize` function described above.

The main difference is that the call to `rerere` first releases everything that has been loaded for the current Client Id and Project Id, then reloads the data for the new Client Id and Project Id. 

Most of the time this should be related to using another version of the project for the same Client Id - both can change.

The name `rerere` comes from the `git rerere` function involved in resolving the same conflicts over and over again until the subject branches are done.

```swift
func rerere(clientId: String, version: String, completionHandler: @escaping (Error?) -> Void)
```

#### showConsentController

The `showConsentController` function shows Axeptio's widget to the user in a given view controller and calls the completion handler when the user has made his choices. If `onlyFirstTime` is true and the user has already made his choices in a previous call the widget is not shown and the completion is called immediately. However if the configuration includes new vendors then the widget is shown again. You can specify an `initialStepIndex` greater than 0 to show a different step directly.

```swift
func showConsentController(initialStepIndex: Int = 0, onlyFirstTime: Bool = true, in viewController: UIViewController, animated: Bool = true, completionHandler: @escaping (Error?) -> Void) -> (() -> Void)?
```

If the widget is displayed, the function returns a reject handler that you can call to hide the widget if necessary. Otherwise, it returns nil.

#### getUserConsent

The `getUserConsent` function returns an optional boolean indicating if the user has made his choice for given vendor and whether or not he gave his consent. If the returned value is `nil` it either means the vendor was not present in the configuration or the widget has not been presented to the user yet.

```swift
func getUserConsent(forVendor name: String) -> Bool?
```

#### setUserConsentToDisagreeWithAll

The `setUserConsentToDisagreeWithAll` function sets consent for all vendors to false and saves the preference. This function is useful when using application tracking transparency. If a user refuses the tracking permission request, call this function to have the CMP not displayed and the user's consent saved in the Axeptio consent log.

# TroubleShouting

## your updated your Pod:with pod update
and your have this warning swhon
```shell
[!] The `AxeptioSDKDemoUITests [Release]` target overrides the `ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES` build setting defined in `Pods/Target Support Files/Pods-AxeptioSDKDemoUITests/Pods-AxeptioSDKDemoUITests.release.xcconfig'. This can lead to problems with the CocoaPods installation
    - Use the `$(inherited)` flag, or
    - Remove the build settings from the target.
```
- open xcode 14 the xcworkspace file of your project 
- then select the pods project in the project inspector 
  - select "build settings" in the tabs above 
  - In the filter edit text, enter ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES.
  - Now you only see this field among the build options as long as the filter is activated.
  - set the value to YES using the context menu if it is not already there
  - the field should become YES 
  - when you deploy it using the triangle sign, both the Release and Debug flavours should be set to YES
- select your project in the project inspector
  - in the project list, select your project
  - in the tab select "build setting", it should already be activated
  - in the filter output you should always have ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES
  - the variable is set to No
  - click to open the context menu on this field
  - select other
  - in the empty pop up window enter $(inherited)
  - the value should become No-$(inherited)
  - when you deploy it using the triangle sign both release and debug flavours must be set to No-$(inherited)
- repeat this for all targets in the release and debug versions for both the app and the test targets you may have using Pods
  - set values to $(inherited)
  - this time fields must be set to Yes-$(inherited)
  - when you deploy it using the triangle sign both release and debug flavours must be set to YES-$(inherited)




    
# References

- CocoaPods
  - https://cocoapods.org
- All CocoaPods' Guide
  - https://guides.cocoapods.org
- Installing CocoaPods with Homebrew
  - https://formulae.brew.sh/formula/cocoapods
- Getting started
  - https://guides.cocoapods.org/using/getting-started.html
- Using CocoaPods
  - https://guides.cocoapods.org/using/using-cocoapods.html
- pod install vs pod update
  - https://guides.cocoapods.org/using/pod-install-vs-update.html
- CocoaPods Command Line reference
  - https://guides.cocoapods.org/terminal/commands.html
- What is a Podfile ?
  - https://guides.cocoapods.org/using/the-podfile.html
- Podfile syntax reference
  - https://guides.cocoapods.org/syntax/podfile.html
- How to remove CocoaPods from Xcode Project ?
  - https://medium.com/app-makers/how-to-remove-cocoapods-from-xcode-project-5166c19152
