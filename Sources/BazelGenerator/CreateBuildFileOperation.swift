//
// CreateBuildFileOperation.swift
// Copyright (c) 2023 Daohan Chong and other XcodeMigrate authors.
// MIT License.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the  Software), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED  AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import PathKit

struct CreateBuildFileOperation: Hashable, Equatable {
    let targetPath: Path
    let rules: [BazelRule]

    init(targetPath: Path, rules: [BazelRule]) {
        self.targetPath = targetPath
        self.rules = rules

        if !targetPath.isAbsolute {
            fatalError("targetPath: \(targetPath) must be absolute")
        }
    }
}

extension CreateBuildFileOperation {
    var ruleLoadingStatements: [String] {
        var ruleLoadingStrings: Set<String> = []

        rules.forEach { bazelRule in
            ruleLoadingStrings.insert(bazelRule.ruleLoadingString)
        }

        return Array(ruleLoadingStrings).sorted()
    }

    static func aggregatedLoadingStatements(of operations: [CreateBuildFileOperation]) -> [String] {
        var ruleLoadingStrings: Set<String> = []

        for operation in operations {
            for loadingStatement in operation.ruleLoadingStatements {
                ruleLoadingStrings.insert(loadingStatement)
            }
        }

        return Array(ruleLoadingStrings)
    }

    var allRules: String {
        rules.map(\.generatedRuleString).joined(separator: "\n")
    }
}
