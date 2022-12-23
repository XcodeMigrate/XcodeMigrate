// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "XcodeMigrate",
    dependencies: [
        .package(url: "https://github.com/tuist/XcodeProj.git", .upToNextMajor(from: "8.8.0")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .executableTarget(
            name: "XcodeMigrate",
            dependencies: [
                "XcodeParser",
            ]
        ),
        .target(name: "XcodeParser", dependencies: ["XcodeProj"]),
        .testTarget(
            name: "XcodeMigrateTests",
            dependencies: ["XcodeMigrate"]
        ),
        .testTarget(
            name: "XcodeParserTests",
            dependencies: ["XcodeParser"]
        ),
    ]
)
