@testable import BazelGenerator
import PathKit
@testable import XcodeAbstraction
import XCTest

final class AbstractTargetPlusBazelGenTests: XCTestCase {
    func testMinimalExample() throws {
        let targetName = "SampleTarget"
        let sourceFile1 = "\(targetName)/Foo.swift"
        let sourceFile2 = "\(targetName)/Bar.swift"
        let sourceFiles = [
            AbstractSourceFile(path: Path(sourceFile1)),
            AbstractSourceFile(path: Path(sourceFile2)),
        ]
        let target = AbstractTarget(name: "SampleTarget", productType: .framework, path: Path(targetName), sourceFiles: sourceFiles, dependencies: [])

        let swiftBazelLibString = try target.bazelGen()

        let expected = """
        swift_library(
            name = "\(targetName)",
            srcs = [
        "\(sourceFile1)",
        "\(sourceFile2)"
        ],
            deps = []
        )
        """

        XCTAssertEqual(expected, swiftBazelLibString)
    }

    func testMinimalTargetWithTwoDependencies() {
        let targetName = "SampleTarget"
        let sourceFile1 = "\(targetName)/Foo.swift"
        let sourceFile2 = "\(targetName)/Bar.swift"
        let sourceFiles = [
            AbstractSourceFile(path: Path(sourceFile1)),
            AbstractSourceFile(path: Path(sourceFile2)),
        ]
        let dependency1 = AbstractTarget(name: "Dependency1", productType: .framework, path: Path("Dependency1"), sourceFiles: [], dependencies: [])
        let dependency2 = AbstractTarget(name: "Dependency2", productType: .framework, path: Path("Dependency2"), sourceFiles: [], dependencies: [])
        let target = AbstractTarget(name: "SampleTarget", productType: .framework, path: Path(targetName), sourceFiles: sourceFiles, dependencies: [dependency1, dependency2])

        let swiftBazelLibString = try! target.bazelGen()

        let expected = """
        swift_library(
            name = "\(targetName)",
            srcs = [
        "\(sourceFile1)",
        "\(sourceFile2)"
        ],
            deps = [
        "//Dependency1",
        "//Dependency2"
        ]
        )
        """

        XCTAssertEqual(expected, swiftBazelLibString)
    }
}
