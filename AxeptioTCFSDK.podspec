#
#  Be sure to run `pod spec lint AxeptioTCFSDK.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|
  spec.name         = "AxeptioTCFSDK"
  spec.version      = ENV['LIB_VERSION'] || '1.0.0'
  spec.summary      = "AxeptioSDK for presenting cookies consent to the user"
  spec.description  = <<-DESC
  The Axeptio SDK for iOS Apps ask and collect consent from the user using a simple Swift API, accessible from both Objective-C and swift projects
                      DESC
  spec.homepage     = "https://github.com/axeptio/tcf-ios-sdk"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "Axeptio" => "support@axeptio.eu" }
  spec.source       = { :git => "https://github.com/axeptio/tcf-ios-sdk.git", :tag => spec.version.to_s }
  spec.vendored_frameworks = "AxeptioSDK.xcframework"
  spec.swift_version = "5.6"
  spec.platform = :ios, "15.0"
  spec.ios.deployment_target = "15.0"
end
