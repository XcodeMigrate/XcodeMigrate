@testable import XcodeParser
import XCTest

final class XcodeParserTests: XCTestCase {
  func testExample() throws {
    let projectFolder = SwiftProjectPath.projectFolder()

    let parser = try XcodeParser(path: "\(projectFolder)/fixtures/basic/BasicFixtureProject.xcodeproj")

    print(parser)

    parser.perform()
  }
}
