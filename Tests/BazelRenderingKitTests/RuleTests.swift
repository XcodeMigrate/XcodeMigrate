//
// RuleTests.swift
// Copyright (c) 2023 Daohan Chong and other XcodeMigrate authors.
// MIT License.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the  Software), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED  AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

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
