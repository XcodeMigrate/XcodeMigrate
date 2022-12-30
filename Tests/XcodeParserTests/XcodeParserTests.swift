import TestSupport
@testable import XcodeParser
import XCTest

final class XcodeParserTests: XCTestCase {
    func testParsingExampleProject() throws {
        let projectFolder = SwiftProjectPath.projectFolder()

        let parser = try XcodeParser(projectPath: "\(projectFolder)/fixtures/basic/BasicFixtureProject.xcodeproj")

        try parser.perform()

        guard let abstractProject = parser.abstractProject else {
            XCTFail("Abstract project should not be nil")
            return
        }

        XCTAssertEqual(abstractProject.targets.count, 6)

        for target in abstractProject.targets {
            XCTAssertEqual(target.deploymentTarget.iOS, "13.0")
        }
    }
}
