//
//  CreateBuildFileOperation.swift
//
//
//  Created by WildCat on 12/26/22.
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

        return Array(ruleLoadingStrings)
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
