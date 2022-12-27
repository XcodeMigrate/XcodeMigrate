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
            AbstractSourceFile(path: sourceFile2)
        ]
        let target = AbstractTarget(name: "SampleTarget", productType: .framework, path: Path(targetName), sourceFiles: sourceFiles, dependencies: [], infoPlistPath: sampleRootPath + Path("Path/To/Info.plist"))

        let generatedOperations = try target.generateBazelFileCreateOperations(rootPath: sampleRootPath)

        let expectedOperations: [CreateBuildFileOperation] = [
            CreateBuildFileOperation(
                targetPath: "/path/of/root/SampleTarget/BUILD.bazel",
                rules: [
                    BazelRule.swiftLibrary(
                        name: "SampleTarget_lib",
                        srcs: ["path/of/root/SampleTarget/Foo.swift", "path/of/root/SampleTarget/Bar.swift"],
                        deps: [],
                        moduleName: "SampleTarget"
                    ),
                    BazelRule.iosFramework(
                        name: "SampleTarget",
                        deps: [":SampleTarget_lib"],
                        bundleID: "to.do.SampleTarget",
                        minimumOSVersion: "13.0",
                        deviceFamilies: [BazelRule.DeviceFamily.iphone],
                        infoPlists: ["//Path/To:SampleTarget_InfoPlist"]
                    )
                ]
            ),

            CreateBuildFileOperation(
                targetPath: "/path/of/root/Path/To/BUILD.bazel",
                rules: [
                    BazelRule.filegroup(
                        name: "SampleTarget_InfoPlist",
                        srcs: ["Info.plist"]
                    )
                ]
            )
        ]

        XCTAssertEqual(expectedOperations.first!, generatedOperations.first!)
        XCTAssertEqual(expectedOperations[1], generatedOperations[1])

        XCTAssertEqual(expectedOperations.count, generatedOperations.count)
    }

    func testMinimalTargetWithTwoDependencies() throws {
        let sampleRootPath = Path("/path/of/root")
        let targetName = "SampleTarget"
        let sourceFile1 = "\(targetName)/Foo.swift"
        let sourceFile2 = "\(targetName)/Bar.swift"
        let sourceFiles = [
            AbstractSourceFile(path: Path(sourceFile1)),
            AbstractSourceFile(path: Path(sourceFile2))
        ]
        let dependency1 = AbstractTarget(name: "Dependency1", productType: .framework, path: Path("Dependency1"), sourceFiles: [], dependencies: [], infoPlistPath: sampleRootPath + Path("Path/To/Info.plist"))
        let dependency2 = AbstractTarget(name: "Dependency2", productType: .framework, path: Path("Dependency2"), sourceFiles: [], dependencies: [], infoPlistPath: sampleRootPath + Path("Path/To/Info.plist"))
        let target = AbstractTarget(name: "SampleTarget", productType: .framework, path: Path(targetName), sourceFiles: sourceFiles, dependencies: [dependency1, dependency2], infoPlistPath: sampleRootPath + Path("Path/To/Info.plist"))

        let generatedOperations = try target.generateBazelFileCreateOperations(rootPath: sampleRootPath)

        let expectedOperations: [CreateBuildFileOperation] = [
            CreateBuildFileOperation(
                targetPath: "/path/of/root/SampleTarget/BUILD.bazel",
                rules: [
                    BazelRule.swiftLibrary(
                        name: "SampleTarget_lib",
                        srcs: ["path/of/root/SampleTarget/Foo.swift", "path/of/root/SampleTarget/Bar.swift"],
                        deps: [":Dependency1", ":Dependency2"],
                        moduleName: "SampleTarget"
                    ),
                    BazelRule.iosFramework(
                        name: "SampleTarget",
                        deps: [":SampleTarget_lib"],
                        bundleID: "to.do.SampleTarget",
                        minimumOSVersion: "13.0",
                        deviceFamilies: [BazelRule.DeviceFamily.iphone],
                        infoPlists: ["//Path/To:SampleTarget_InfoPlist"]
                    )
                ]
            ),

            CreateBuildFileOperation(
                targetPath: "/path/of/root/Path/To/BUILD.bazel",
                rules: [
                    BazelRule.filegroup(
                        name: "SampleTarget_InfoPlist",
                        srcs: ["Info.plist"]
                    )
                ]
            )
        ]

        XCTAssertEqual(generatedOperations, expectedOperations)
    }
}
