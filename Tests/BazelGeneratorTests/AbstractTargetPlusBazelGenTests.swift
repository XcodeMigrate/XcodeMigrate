//
// AbstractTargetPlusBazelGenTests.swift
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
@testable import XcodeAbstraction
import XCTest

final class AbstractTargetPlusBazelGenTests: XCTestCase {
    func testMinimalExample() throws {
        let sampleRootPath = Path("/path/of/root")
        let targetName = "SampleTarget"
        let sourceFile1 = sampleRootPath + "\(targetName)/Foo.swift"
        let sourceFile2 = sampleRootPath + "\(targetName)/Bar.swift"
        let sourceFiles = [
            AbstractSourceFile(path: sourceFile1),
            AbstractSourceFile(path: sourceFile2),
        ]
        let target = AbstractTarget(
            name: "SampleTarget",
            productType: .framework,
            bundleIdentifier: "com.example.SampleTarget",
            path: Path(targetName),
            sourceFiles: sourceFiles,
            resources: [],
            dependencies: [],
            infoPlistPath: sampleRootPath + Path("Path/To/Info.plist"),
            deploymentTarget: DeploymentTarget(iOS: "13.0"),
            targetDevice: [.iphone, .ipad]
        )

        let generatedOperations = try target.generateBazelFileCreateOperations(projectRoot: sampleRootPath)

        let expectedOperations: [CreateBuildFileOperation] = [
            CreateBuildFileOperation(
                targetPath: "/path/of/root/SampleTarget/BUILD.bazel",
                rules: [
                    BazelRule.swiftLibrary(
                        name: "SampleTarget_lib",
                        srcs: ["Foo.swift", "Bar.swift"],
                        deps: [],
                        moduleName: "SampleTarget"
                    ),
                    BazelRule.iosFramework(
                        name: "SampleTarget",
                        deps: [":SampleTarget_lib"],
                        bundleID: "com.example.SampleTarget",
                        minimumOSVersion: "13.0",
                        deviceFamilies: [.iphone, .ipad],
                        infoPlists: ["//Path/To:SampleTarget_InfoPlist"],
                        resources: []
                    ),
                ]
            ),

            CreateBuildFileOperation(
                targetPath: "/path/of/root/Path/To/BUILD.bazel",
                rules: [
                    BazelRule.filegroup(
                        name: "SampleTarget_InfoPlist",
                        srcs: ["Info.plist"]
                    ),
                ]
            ),
        ]

        CreateBuildFileOperation.assertCreateBuildFileOperationEqual(expectedOperations.first!, generatedOperations.first!)
        CreateBuildFileOperation.assertCreateBuildFileOperationEqual(expectedOperations[1], generatedOperations[1])
        XCTAssertEqual(expectedOperations.count, generatedOperations.count)
    }

    func testMinimalTargetWithTwoDependencies() throws {
        let sampleRootPath = Path("/path/of/root")
        let targetName = "SampleTarget"
        let sourceFile1 = sampleRootPath + "\(targetName)/Foo.swift"
        let sourceFile2 = sampleRootPath + "\(targetName)/Bar.swift"
        let sourceFiles = [
            AbstractSourceFile(path: sourceFile1),
            AbstractSourceFile(path: sourceFile2),
        ]
        let dependency1 = AbstractTarget(name: "Dependency1", productType: .framework, bundleIdentifier: "com.example.Dependency1", path: sampleRootPath + Path("Dependency1"), sourceFiles: [], resources: [], dependencies: [], infoPlistPath: sampleRootPath + Path("Path/To/Info.plist"), deploymentTarget: DeploymentTarget(iOS: "13.0"), targetDevice: [.iphone])
        let dependency2 = AbstractTarget(name: "Dependency2", productType: .framework, bundleIdentifier: "com.example.Dependency2", path: sampleRootPath + Path("Dependency2"), sourceFiles: [], resources: [], dependencies: [], infoPlistPath: sampleRootPath + Path("Path/To/Info.plist"), deploymentTarget: DeploymentTarget(iOS: "13.0"), targetDevice: [.iphone])
        let target = AbstractTarget(name: "SampleTarget", productType: .framework, bundleIdentifier: "com.example.SampleTarget", path: sampleRootPath + Path(targetName), sourceFiles: sourceFiles, resources: [AbstractSourceFile(path: sampleRootPath + targetName + "index.html")], dependencies: [dependency1, dependency2], infoPlistPath: sampleRootPath + Path("Path/To/Info.plist"), deploymentTarget: DeploymentTarget(iOS: "13.0"), targetDevice: [.iphone])

        let generatedOperations = try target.generateBazelFileCreateOperations(projectRoot: sampleRootPath)

        let expectedOperations: [CreateBuildFileOperation] = [
            CreateBuildFileOperation(
                targetPath: "/path/of/root/SampleTarget/BUILD.bazel",
                rules: [
                    BazelRule.swiftLibrary(name: "SampleTarget_lib", srcs: ["Foo.swift", "Bar.swift"], deps: ["//Dependency1:Dependency1", "//Dependency2:Dependency2"], moduleName: "SampleTarget"),
                    BazelRule.iosFramework(name: "SampleTarget", deps: [":SampleTarget_lib"], bundleID: "com.example.SampleTarget", minimumOSVersion: "13.0", deviceFamilies: [BazelRule.DeviceFamily.iphone], infoPlists: ["//Path/To:SampleTarget_InfoPlist"], resources: ["index.html"]),
                ]
            ),
            CreateBuildFileOperation(
                targetPath: "/path/of/root/Path/To/BUILD.bazel",
                rules: [
                    BazelRule.filegroup(name: "SampleTarget_InfoPlist", srcs: ["Info.plist"]),
                ]
            ),
        ]

        XCTAssertEqual(generatedOperations.count, expectedOperations.count)
        CreateBuildFileOperation.assertCreateBuildFileOperationEqual(generatedOperations[0], expectedOperations[0])
        CreateBuildFileOperation.assertCreateBuildFileOperationEqual(generatedOperations[1], expectedOperations[1])
    }
}
