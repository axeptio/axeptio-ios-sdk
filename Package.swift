// swift-tools-version:5.3
import PackageDescription

let package = Package(
	name: "AxeptioSDK",
	platforms: [
		.iOS(.v12)
	],
	products: [
		.library(name: "AxeptioSDK", targets: ["AxeptioSDK"])
	],
	dependencies: [
		.package(
			name: "KeychainSwift",
			url: "https://github.com/evgenyneu/keychain-swift.git",
			.upToNextMajor(from: "20.0.0")
		),
		.package(
			name: "Kingfisher",
			url: "https://github.com/onevcat/Kingfisher.git",
			.upToNextMajor(from: "7.0.0")
		)
	],
	targets: [
		.binaryTarget(
			name: "AxeptioSDK",
			path: "AxeptioSDK/AxeptioSDK.xcframework"
		),
		.target(
			name: "AxeptioSDKWrapper",
			dependencies: [
				.target(name: "AxeptioSDK"),
				.product(name: "KeychainSwift", package: "KeychainSwift"),
				.product(name: "Kingfisher", package: "Kingfisher")
			]
		)
	]
)
