//
// BazelRule.swift
// Copyright (c) 2023 Daohan Chong and other XcodeMigrate authors.
// MIT License.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the  Software), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED  AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import XcodeAbstraction

@frozen enum BazelRule: Hashable {
    case swiftLibrary(name: String, srcs: [String], deps: [String], moduleName: String)
    case iosApplication(name: String, deps: [String], bundleID: String, infoplists: [String], minimumOSVersion: String, deviceFamilies: [BazelRule.DeviceFamily], resources: [String])
    case iosFramework(name: String, deps: [String], bundleID: String, minimumOSVersion: String, deviceFamilies: [BazelRule.DeviceFamily], infoPlists: [String], resources: [String])

    /// iOS Unit Test
    /// <https://github.com/bazelbuild/rules_apple/blob/master/doc/rules-ios.md#ios_unit_test>
    case iosUnitTest(name: String, data: [String], deps: [String], env: [String: String], platformType: BazelRule.DeviceFamily, runner: String, testFilter: String, testHost: String)
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
        case .iosUnitTest:
            return .apple
        case .filegroup:
            return .builtIn
        }
    }

    var ruleLabel: String {
        switch self {
        case let .swiftLibrary(name, _, _, _):
            return name
        case let .iosApplication(name, _, _, _, _, _, _):
            return name
        case let .iosFramework(name, _, _, _, _, _, _):
            return name
        case let .iosUnitTest(name, _, _, _, _, _, _, _):
            return name
        case let .filegroup(name, _):
            return name
        }
    }
}

extension BazelRule {
    var generatedRuleString: String {
        renderedRule.stringRepresentation
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
        case .iosUnitTest:
            return """
            load("@build_bazel_rules_apple//apple:ios.bzl", "ios_unit_test")
            """
        case .filegroup:
            return ""
        }
    }
}
