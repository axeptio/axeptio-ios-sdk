> [!CAUTION]
> This SDK is the old Axeptio flavor and is now deprecated. Please go to [axeptio/sample-app-ios](https://github.com/axeptio/sample-app-ios) to discover our brand new TCF compliant SDK with sample apps in Objective C and Swift covering many use cases.

# AxeptioSDK

User consent is not limited to the web, but applies to all platforms that collect user data. This includes mobile devices.

## Author

Axeptio

## License

AxeptioSDK is available under the MIT license. See the LICENSE file for more information.

## Changelog

####  **0.5** (iOS 12+)
- Swift package manager integration



# Installation

### Swift Package Manager

- File > Add Packages…
- Add https://github.com/axeptio/axeptio-ios-sdk.git
- Select "Up to Next Major Version" with "0.5.0"

### CocoaPods

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '12.0'
use_frameworks!

target 'MyApp' do
  pod 'AxeptioSDK', '~> 0.5.0'
end
```

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

If your application supports multiple languages, you have probably created a different version for each of them in the Axeptio [administration web page](https://admin.axeptio.eu). In this case you can store the version for each language in the `Localizable.strings` file and use `NSLocalizedString` to get the appropriate version for the user.

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
