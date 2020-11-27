// swift-tools-version:5.3

import PackageDescription

let package = Package(
	name: "MBMobileSDK",
	platforms: [
		.iOS(.v12),
	],
	products: [
		.library(name: "MBMobileSDK",
				 targets: ["MBMobileSDK"])
	],
	dependencies: [
		.package(name: "MBCommonKit",
				 url: "https://github.com/Daimler/MBSDK-CommonKit-iOS.git",
				 .upToNextMajor(from: "3.0.0")),
		.package(name: "MBNetworkKit",
				 url: "https://github.com/Daimler/MBSDK-NetworkKit-iOS.git",
				 .upToNextMajor(from: "3.0.0")),
		.package(name: "MBRealmKit",
				 url: "https://github.com/Daimler/MBSDK-RealmKit-iOS.git",
				 .upToNextMajor(from: "3.0.0")),
		.package(name: "SwiftProtobuf",
				 url: "https://github.com/apple/swift-protobuf.git",
				 .upToNextMajor(from: "1.0.0")),
		.package(url: "https://github.com/jrendel/SwiftKeychainWrapper.git",
				 .upToNextMajor(from: "4.0.0")),
		.package(url: "https://github.com/weichsel/ZIPFoundation.git",
				 .upToNextMajor(from: "0.9.0")),
		.package(url: "https://github.com/AliSoftware/OHHTTPStubs.git",
				 .upToNextMajor(from: "9.0.0")),
		.package(url: "https://github.com/Quick/Nimble.git",
				 .upToNextMajor(from: "8.0.0")),
		.package(url: "https://github.com/Quick/Quick.git",
				 .upToNextMajor(from: "2.0.0"))
	],
	targets: [
		.target(name: "MBMobileSDK",
				dependencies: [
					.byName(name: "MBCommonKit"),
					.byName(name: "MBNetworkKit"),
					.byName(name: "MBRealmKit"),
					.byName(name: "SwiftProtobuf"),
					.product(name: "SwiftKeychainWrapper", package: "SwiftKeychainWrapper"),
					.product(name: "ZIPFoundation", package: "ZIPFoundation")
				],
				path: "MBMobileSDK/MBMobileSDK",
				exclude: [
					"Info.plist",
					"Generated/Templates/TrackingEvent.stencil"
				]),
		.testTarget(name: "MBMobileSDKTests",
					dependencies: [
						.byName(name: "Nimble"),
						.byName(name: "Quick"),
						.product(name: "OHHTTPStubsSwift", package: "OHHTTPStubs")
					],
					path: "MBMobileSDK/MBMobileSDKTests",
					exclude: ["Info.plist"],
					resources: [
						.copy("Resources"),
						.copy("Subs")
					])
	],
	swiftLanguageVersions: [.v5]
)
