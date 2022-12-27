// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "XcodeMigrate",
    dependencies: [
        .package(url: "https://github.com/tuist/XcodeProj.git", .upToNextMajor(from: "8.8.0")),
        .package(url: "https://github.com/kylef/PathKit.git", .upToNextMajor(from: "1.0.1")),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .executableTarget(
            name: "XcodeMigrate",
            dependencies: [
                "XcodeParser",
                "Common",
            ]
        ),
        .target(name: "XcodeParser", dependencies: ["XcodeProj", "XcodeAbstraction", "FoundationExtension"]),
        .target(name: "BazelGenerator", dependencies: ["XcodeAbstraction", "PathKit", "XcodeParser", "Common"]),

        // Intermediate Abstraction of Xcode Project without dependening on `XcodeProj`
        .target(name: "XcodeAbstraction", dependencies: ["FoundationExtension", "PathKit"]),

        .target(name: "FoundationExtension"),

        .target(name: "Common", dependencies: [
            .product(name: "Logging", package: "swift-log"),
        ]),
        .target(name: "TestSupport", path: "Tests/TestSupport"),
        .testTarget(
            name: "XcodeMigrateTests",
            dependencies: ["XcodeMigrate"]
        ),
        .testTarget(
            name: "XcodeParserTests",
            dependencies: ["XcodeParser", "TestSupport"]
        ),
        .testTarget(name: "BazelGeneratorTests", dependencies: ["BazelGenerator", "TestSupport"]),
    ]
)
