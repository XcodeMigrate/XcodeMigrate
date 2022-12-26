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
            deps = "[]"
        )
        """

        XCTAssertEqual(expected, swiftBazelLibString)
    }
}
