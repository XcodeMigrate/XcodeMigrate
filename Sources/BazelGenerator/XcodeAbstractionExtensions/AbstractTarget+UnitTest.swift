//
// AbstractTarget+UnitTest.swift
// Copyright (c) 2023 Daohan Chong and other XcodeMigrate authors.
// MIT License.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the  Software), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED  AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import Common
import FoundationExtension
import PathKit
import XcodeAbstraction

extension AbstractTarget {
    func generateUnitTestBundle(projectRoot: Path) -> [CreateBuildFileOperation] {
        let targetSource = targetSourceSwift(projectRoot: projectRoot)
        let sourceLabel = targetSource.ruleLabel

        let buildFilePath = path + "BUILD.bazel"

        return [
            CreateBuildFileOperation(
                targetPath: buildFilePath,
                rules: [
                    .iosUnitTest(
                        name: name,
                        data: [],
                        deps: [":\(sourceLabel)"],
                        env: [:],
                        platformType: .iphone,
                        runner: "@build_bazel_rules_apple//apple/testing/default_runner:ios_xctestrun_ordered_runner",
                        testFilter: "",
                        testHost: ""
                    ),
                    targetSource,
                ]
            ),
        ]
    }
}
