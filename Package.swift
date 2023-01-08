// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "XcodeMigrate",
    products: [
        .executable(name: "xcode-migrate", targets: [
            "XcodeMigrate",
        ]),
    ],
    dependencies: [
        .package(url: "https://github.com/tuist/XcodeProj.git", .upToNextMajor(from: "8.8.0")),
        .package(url: "https://github.com/kylef/PathKit.git", .upToNextMajor(from: "1.0.1")),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.0"),
        .package(url: "https://github.com/apple/swift-collections.git", from: "1.0.4"),
        .package(url: "https://github.com/jpsim/Yams.git", from: "5.0.1"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .executableTarget(
            name: "XcodeMigrate",
            dependencies: [
                "BazelGenerator",
                "XcodeParser",
                "Common",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "Yams", package: "Yams"),
            ]
        ),
        .target(name: "XcodeParser", dependencies: ["Common", "XcodeProj", "XcodeAbstraction", "FoundationExtension"]),
        .target(name: "BazelGenerator", dependencies: ["XcodeAbstraction", "PathKit", "XcodeParser", "Common", "BazelRenderingKit"]),

        // Intermediate Abstraction of Xcode Project without dependening on `XcodeProj`
        .target(name: "XcodeAbstraction", dependencies: ["FoundationExtension", "PathKit"]),

        .target(name: "FoundationExtension"),
        .target(name: "BazelRenderingKit", dependencies: [
            .product(name: "Collections", package: "swift-collections"),
        ]),

        .target(name: "Common", dependencies: [
            .product(name: "Logging", package: "swift-log"),
            "PathKit",
        ]),
        .target(name: "TestSupport", path: "Tests/TestSupport"),
        .testTarget(name: "CommonTests", dependencies: [
            "Common",
            .product(name: "Yams", package: "Yams"),
        ]),
        .testTarget(
            name: "XcodeMigrateTests",
            dependencies: ["XcodeMigrate"]
        ),
        .testTarget(
            name: "XcodeParserTests",
            dependencies: ["XcodeParser", "TestSupport"]
        ),
        .testTarget(name: "BazelGeneratorTests", dependencies: ["BazelGenerator", "TestSupport"]),
        .testTarget(name: "BazelRenderingKitTests", dependencies: [
            "BazelRenderingKit",
            "TestSupport",
        ]),
    ]
)
