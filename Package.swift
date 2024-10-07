// swift-tools-version:5.6
import PackageDescription

let package = Package(
	name: "AxeptioSDK",
	platforms: [
		.iOS(.v15)
	],
	products: [
		.library(name: "AxeptioSDK", targets: ["AxeptioSDK"])
	],
	targets: [
		.binaryTarget(
			name: "AxeptioSDK",
            path: "AxeptioSDK.xcframework"
		)
	]
)