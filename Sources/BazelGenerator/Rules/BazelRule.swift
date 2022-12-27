import XcodeAbstraction

@frozen enum BazelRule {
    case swiftLibrary(name: String, srcs: [String], deps: [String])
    case iosApplication(name: String, deps: [String])
    case iosFramework(name: String, deps: [String], bundleID: String, minimumOSVersion: String, deviceFamilies: [BazelRule.DeviceFamily], infoPlists: [String])
}

extension BazelRule {
    var ruleSet: BazelRuleSet {
        switch self {
        case .swiftLibrary:
            return .swift
        case .iosApplication:
            return .apple
        case .iosFramework:
            return .apple
        }
    }
}

extension BazelRule {
    var generatedRuleString: String {
        switch self {
        case let .swiftLibrary(name, srcs, deps):
            return """
            swift_library(
                name = "\(name)",
                srcs = \(srcs.toArrayLiteralString()),
                deps = \(deps.toArrayLiteralString()),
                visibility = ["//visibility:public"],
            )
            """
        case let .iosApplication(name, deps):
            return """
            ios_application(
                name = "\(name)",
                deps = \(deps.toArrayLiteralString())
            )
            """
        case let .iosFramework(name, deps, bundleID, minimumOSVersion, deviceFamilies, infoPlists):
            return """
            ios_framework(
                name = "\(name)",
                bundle_id = "\(bundleID)",
                families = \(deviceFamilies.map(\.rawValue).toArrayLiteralString()),
                infoplists = \(infoPlists.toArrayLiteralString()),
                minimum_os_version = "\(minimumOSVersion)",
                visibility = ["//visibility:public"],
                deps = \(deps.toArrayLiteralString()),
            )
            """
        }
    }

    var ruleLoadingString: String {
        switch self {
        case .swiftLibrary:
            return """
            load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")
            """
        case .iosApplication:
            return """
            load("@build_bazel_rules_apple//apple:ios.bzl", "ios_application")
            """
        case .iosFramework:
            return #"load("@build_bazel_rules_apple//apple:ios.bzl", "ios_framework")"#
        }
    }
}
