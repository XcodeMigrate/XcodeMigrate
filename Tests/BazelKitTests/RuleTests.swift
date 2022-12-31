@testable import BazelKit
import Foundation
import XCTest

class RuleTests: XCTestCase {
  func testStringRepresentation() {
    let rule1 = Rule(name: "swift_library")
      .attr(key: "name", value: "MyLibrary")
      .attr(key: "srcs", value: ["foo.swift", "bar.swift"])
      .attr(key: "deps", value: ["//foo:bar"])
    XCTAssertEqual(rule1.stringRepresentation, "swift_library(name=MyLibrary, srcs=[\"foo.swift\",\"bar.swift\"], deps=[\"//foo:bar\"])")

    let rule2 = Rule(name: "ios_framework")
      .attr(key: "name", value: "MyFramework")
      .attr(key: "srcs", value: ["foo.swift", "bar.swift"])
      .attr(key: "deps", value: ["//foo:bar"])
      .attr(key: "platforms", value: ["ios"])
    XCTAssertEqual(rule2.stringRepresentation, "ios_framework(name=MyFramework, srcs=[\"foo.swift\",\"bar.swift\"], deps=[\"//foo:bar\"], platforms=[\"ios\"])")
  }
}
