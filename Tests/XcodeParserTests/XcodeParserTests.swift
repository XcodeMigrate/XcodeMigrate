@testable import XcodeParser
import XCTest

final class XcodeParserTests: XCTestCase {
    func testExample() throws {
        let projectFolder = SwiftProjectPath.projectFolder()

        let parser = try XcodeParser(projectPath: "\(projectFolder)/fixtures/basic/BasicFixtureProject.xcodeproj")

        print(parser)

        try parser.perform()
    }
}
