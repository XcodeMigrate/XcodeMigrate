@testable import BazelGenerator
import PathKit
@testable import XcodeAbstraction
import XCTest

final class AbstractTargetPlusBazelGenTests: XCTestCase {
    func testExample() throws {
        let targetName = "SampleTarget"
        let sourceFile1 = "\(targetName)/Foo.swift"
        let sourceFile2 = "\(targetName)/Bar.swift"
        let sourceFiles = [
            AbstractSourceFile(path: Path(sourceFile1)),
            AbstractSourceFile(path: Path(sourceFile2)),
        ]
        let target = AbstractTarget(name: "SampleTarget", productType: .framework, path: Path(targetName), sourceFile: sourceFiles)

        let swiftBazelLibString = try target.bazelGen()

        XCTAssertEqual("swift_library(\n    name = \"\(targetName)\",\n    srcs = [\"\(sourceFile1)\",\n\"\(sourceFile2)\"]\n)", swiftBazelLibString)
    }
}
