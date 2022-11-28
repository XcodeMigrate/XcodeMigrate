@testable import XcodeParser
import XCTest

final class XcodeParserTests: XCTestCase {
  func testExample() throws {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct
    // results.

    let projectFolder = SwiftProjectPath.projectFolder()
      
    let parser = try XcodeParser(path: "\(projectFolder)/fixtures/basic/BasicFixtureProject.xcodeproj")

    print(parser)
  }
}
