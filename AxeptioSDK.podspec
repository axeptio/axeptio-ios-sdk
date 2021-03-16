#
# Be sure to run `pod lib lint AxeptioSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AxeptioSDK'
  s.version          = '0.1.0'
  s.summary          = 'Axeptio SDK for presenting cookies consent to the user'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  Axeptio SDK for presenting cookies consent to the user
                       DESC

  s.homepage         = 'https://github.com/agilitation/axeptio-ios-sdk'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Axeptio' => 'support@axeptio.eu' }
  s.source           = { :git => 'https://github.com/agilitation/axeptio-ios-sdk.git', :tag => s.version.to_s }

  s.swift_version = '5.0'
  s.ios.deployment_target = '11.0'

  s.preserve_paths = 'AxeptioSDK/Axeptio.xcframework'
  s.vendored_frameworks = 'AxeptioSDK/Axeptio.xcframework'
  
  s.frameworks = 'UIKit'
  s.dependency 'KeychainSwift'
  s.dependency 'Alamofire', '~> 5.2'
  s.dependency 'Kingfisher'
end
