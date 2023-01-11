//
// CreateBuildFileOperation+TestHelpers.swift
// Copyright (c) 2023 Daohan Chong and other XcodeMigrate authors.
// MIT License.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the  Software), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED  AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

@testable import BazelGenerator
import XCTest

extension CreateBuildFileOperation {
    static func assertCreateBuildFileOperationEqual(_ lhs: CreateBuildFileOperation, _ rhs: CreateBuildFileOperation) {
        XCTAssertEqual(lhs.targetPath, rhs.targetPath)
        XCTAssertEqual(lhs.rules.count, rhs.rules.count)
        for (index, rule) in lhs.rules.enumerated() {
            assertBazelRuleEqual(rule, rhs.rules[index])
        }
    }
}

private extension CreateBuildFileOperation {
    static func assertBazelRuleEqual(_ lhs: BazelRule, _ rhs: BazelRule) {
        switch (lhs, rhs) {
        case let (.iosFramework(lhsName, lhsDeps, lhsBundleID, lhsMinimumOSVersion, lhsDeviceFamilies, lhsInfoPlists, lhsResources),
                  .iosFramework(rhsName, rhsDeps, rhsBundleID, rhsMinimumOSVersion, rhsDeviceFamilies, rhsInfoPlists, rhsResources)):
            XCTAssertEqual(lhsName, rhsName)
            XCTAssertEqual(lhsDeps, rhsDeps)
            XCTAssertEqual(lhsBundleID, rhsBundleID)
            XCTAssertEqual(lhsMinimumOSVersion, rhsMinimumOSVersion)
            XCTAssertEqual(lhsDeviceFamilies, rhsDeviceFamilies)
            XCTAssertEqual(lhsInfoPlists, rhsInfoPlists)
            XCTAssertEqual(lhsResources, rhsResources)
        case let (.swiftLibrary(lhsName, lhsSrcs, lhsDeps, lhsModuleName),
                  .swiftLibrary(rhsName, rhsSrcs, rhsDeps, rhsModuleName)):
            XCTAssertEqual(lhsName, rhsName)
            XCTAssertEqual(lhsSrcs, rhsSrcs)
            XCTAssertEqual(lhsDeps, rhsDeps)
            XCTAssertEqual(lhsModuleName, rhsModuleName)
        case let (.filegroup(lhsName, lhsSrcs),
                  .filegroup(rhsName, rhsSrcs)):
            XCTAssertEqual(lhsName, rhsName)
            XCTAssertEqual(lhsSrcs, rhsSrcs)
        default:
            XCTFail("BazelRule is not equal\nlhs: \(lhs)\nrhs: \(rhs)")
        }
    }
}
