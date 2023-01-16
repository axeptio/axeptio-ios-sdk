// swift-tools-version:5.3
import PackageDescription

let package = Package(
	name: "AxeptioSDK",
	platforms: [
		.iOS(.v12)
	],
	products: [
		.library( name: "AxeptioSDK", targets: ["AxeptioSDK"])
	],
	dependencies: [
		.package(url: "https://github.com/evgenyneu/keychain-swift.git", from: "20.0.0")
		.package(url: "https://github.com/onevcat/Kingfisher.git", from: "7.0.0")
	],
	targets: [
		.binaryTarget(name: "AxeptioSDK", path: "AxeptioSDK/AxeptioSDK.xcframework")
	]
)
