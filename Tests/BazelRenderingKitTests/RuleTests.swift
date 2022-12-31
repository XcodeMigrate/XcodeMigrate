@testable import BazelRenderingKit
import Foundation
import XCTest

class RuleTests: XCTestCase {
    func testStringRepresentation() {
        let rule1 = Rule(name: "swift_library")
            .attr(key: "name", value: "MyLibrary")
            .attr(key: "srcs", value: ["foo.swift", "bar.swift"])
            .attr(key: "deps", value: ["//foo:bar"])
        assertRuleStringEqual(rule1, #"swift_library(name="MyLibrary", srcs=["foo.swift","bar.swift"], deps=["//foo:bar"])"#)

        let rule2 = Rule(name: "ios_framework")
            .attr(key: "name", value: "MyFramework")
            .attr(key: "srcs", value: ["foo.swift", "bar.swift"])
            .attr(key: "deps", value: ["//foo:bar"])
            .attr(key: "platforms", value: ["ios"])
        XCTAssertEqual(rule2.stringRepresentation, #"ios_framework(name="MyFramework", srcs=["foo.swift","bar.swift"], deps=["//foo:bar"], platforms=["ios"])"#)
    }
}

private extension RuleTests {
    func assertRuleStringEqual(_ rule: Rule, _ expected: String) {
        let ruleLines = rule.stringRepresentation.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        let expectedLines = expected.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }

        XCTAssertEqual(ruleLines.count, expectedLines.count)

        for (ruleLine, expectedLine) in zip(ruleLines, expectedLines) {
            XCTAssertEqual(ruleLine, expectedLine)
        }
    }
}
