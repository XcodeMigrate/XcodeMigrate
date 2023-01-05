//
// BazelRuleSet.swift
// Copyright (c) 2023 Daohan Chong and other XcodeMigrate authors.
// MIT License.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the  Software), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED  AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

enum BazelRuleSet: Int, Hashable {
    case swift
    case apple

    case builtIn
}

extension BazelRuleSet {
    var workspaceContent: String {
        switch self {
        case .swift:
            return """
            http_archive(
                name = "build_bazel_rules_swift",
                sha256 = "32f95dbe6a88eb298aaa790f05065434f32a662c65ec0a6aabdaf6881e4f169f",
                url = "https://github.com/bazelbuild/rules_swift/releases/download/1.5.0/rules_swift.1.5.0.tar.gz",
            )

            load(
                "@build_bazel_rules_swift//swift:repositories.bzl",
                "swift_rules_dependencies",
            )

            swift_rules_dependencies()

            load(
                "@build_bazel_rules_swift//swift:extras.bzl",
                "swift_rules_extra_dependencies",
            )

            swift_rules_extra_dependencies()
            """
        case .apple:
            return """
            http_archive(
                name = "build_bazel_rules_apple",
                sha256 = "43737f28a578d8d8d7ab7df2fb80225a6b23b9af9655fcdc66ae38eb2abcf2ed",
                url = "https://github.com/bazelbuild/rules_apple/releases/download/2.0.0/rules_apple.2.0.0.tar.gz",
            )

            load(
                "@build_bazel_rules_apple//apple:repositories.bzl",
                "apple_rules_dependencies",
            )

            apple_rules_dependencies()

            load(
                "@build_bazel_rules_swift//swift:repositories.bzl",
                "swift_rules_dependencies",
            )

            swift_rules_dependencies()

            load(
                "@build_bazel_rules_swift//swift:extras.bzl",
                "swift_rules_extra_dependencies",
            )

            swift_rules_extra_dependencies()

            load(
                "@build_bazel_apple_support//lib:repositories.bzl",
                "apple_support_dependencies",
            )

            apple_support_dependencies()
            """
        case .builtIn:
            return ""
        }
    }
}
