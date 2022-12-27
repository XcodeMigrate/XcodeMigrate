@testable import BazelGenerator
import PathKit
import TestSupport
@testable import XcodeAbstraction
@testable import XcodeParser
import XCTest

final class BazelGeneratorTests: XCTestCase {
    func testBazelGenerator() throws {
        let projectFolder = SwiftProjectPath.projectFolder()

        let parser = try XcodeParser(projectPath: "\(projectFolder)/fixtures/basic/BasicFixtureProject.xcodeproj")

        try parser.perform()
        try BazelGenerator.generate(from: parser.abstractProject!)
    }
}
