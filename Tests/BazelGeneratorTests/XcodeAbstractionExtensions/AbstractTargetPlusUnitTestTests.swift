//
// AbstractTargetPlusUnitTestTests.swift
// Copyright (c) 2023 Daohan Chong and other XcodeMigrate authors.
// MIT License.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the  Software), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED  AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

@testable import BazelGenerator
import PathKit
import XcodeAbstraction
import XCTest

class AbstractTargetPlusUnitTestTests: XCTestCase {
    func testUnitTestTarget() throws {
        let dummyProjectRoot = Path("/path/to/proj/root")
        let pathToTestTargetRoot = dummyProjectRoot + "FooTests"
        let dummySourceFiles: [Path] = [
            "FooTests.swift",
            "FooTests2.swift",
        ].map {
            pathToTestTargetRoot + $0
        }

        let target = AbstractTarget(
            name: "SampleTargetTests",
            productType: .unitTestBundle,
            bundleIdentifier: "com.example.SampleTargetTests",
            path: pathToTestTargetRoot,
            sourceFiles: dummySourceFiles.map { AbstractSourceFile(path: $0) },
            resources: [],
            dependencies: [],
            infoPlistPath: pathToTestTargetRoot + Path("Path/To/Info.plist"),
            deploymentTarget: DeploymentTarget(iOS: "13.0"),
            targetDevice: [.iphone, .ipad]
        )

        let generatedOperations = try target.generateBazelFileCreateOperations(projectRoot: dummyProjectRoot)

        let expectedOperations: [CreateBuildFileOperation] = [
            CreateBuildFileOperation(
                targetPath: target.path + "BUILD.bazel",
                rules: [
                    .swiftLibrary(
                        name: "SampleTargetTests_source",
                        srcs: dummySourceFiles.map { $0.relative(from: dummyProjectRoot).string },
                        deps: [],
                        moduleName: "SampleTargetTests"
                    ),
                    .iosUnitTest(
                        name: "SampleTargetTests",
                        data: [],
                        deps: [":SampleTargetTests_source"],
                        minimumOSVersion: "12.0",
                        env: [:],
                        platformType: .iphone,
                        runner: "@build_bazel_rules_apple//apple/testing/default_runner:ios_xctestrun_ordered_runner",
                        testFilter: "",
                        testHost: ""
                    ),
                ]
            ),
        ]

        for (index, operation) in generatedOperations.enumerated() {
            CreateBuildFileOperation.assertCreateBuildFileOperationEqual(operation, expectedOperations[index])
        }
    }
}
