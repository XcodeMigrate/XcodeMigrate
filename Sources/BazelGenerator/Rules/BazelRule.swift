import XcodeAbstraction

@frozen enum BazelRule: Hashable {
    case swiftLibrary(name: String, srcs: [String], deps: [String], moduleName: String)
    case iosApplication(name: String, deps: [String], infoplists: [String], minimumOSVersion: String, deviceFamilies: [BazelRule.DeviceFamily])
    case iosFramework(name: String, deps: [String], bundleID: String, minimumOSVersion: String, deviceFamilies: [BazelRule.DeviceFamily], infoPlists: [String])
    case filegroup(name: String, srcs: [String])
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
        case .filegroup:
            return .builtIn
        }
    }
}

extension BazelRule {
    var generatedRuleString: String {
        return renderedRule.stringRepresentation
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
        case .filegroup:
            return ""
        }
    }
}
