import Foundation
import PathKit
import XcodeAbstraction

public enum BazelGenerator {}

public extension BazelGenerator {
    static func generate(from project: AbstractProject) throws {
        let fileManager = FileManager.default

        // Create BUILD files

        var ruleSet: Set<BazelRuleSet> = []
        for target in project.targets {
            guard let generatedRules = try? target.generateRules() else {
                // TODO: Test all supported product types
                continue
            }
            var ruleLoadingStrings: Set<String> = []
            var ruleStrings: [String] = []
            for generatedRule in generatedRules {
                ruleSet.insert(generatedRule.ruleSet)
                ruleLoadingStrings.insert(generatedRule.ruleLoadingString)

                ruleStrings.append(generatedRule.generatedRuleString)
            }

            let loadingStatements = ruleLoadingStrings.joined(separator: "\n")
            let loadingStatementsAndRules = loadingStatements + "\n" + ruleStrings.joined(separator: "\n")

            let buildFilePath = target.buildFilePath()
            let normalizedBuildFilePath: Path = {
                if buildFilePath.isAbsolute {
                    return buildFilePath
                } else {
                    return project.rootPath + buildFilePath
                }
            }()

            if fileManager.fileExists(atPath: normalizedBuildFilePath.string) {
                try fileManager.removeItem(at: normalizedBuildFilePath.url)
            }

            fileManager.createFile(atPath: normalizedBuildFilePath.string, contents: loadingStatementsAndRules.data(using: .utf8), attributes: nil)
        }

        // Create WORKSPACE
        let workspaceRuleSetStrings = ruleSet.map(\.workspaceContent)

        let httpArchive = """
        load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
        """
        let workspaceString = httpArchive + "\n" + workspaceRuleSetStrings.joined(separator: "\n")

        let workspaceFilePath = project.rootPath + "WORKSPACE"

        if fileManager.fileExists(atPath: workspaceFilePath.string) {
            try fileManager.removeItem(at: workspaceFilePath.url)
        }

        fileManager.createFile(atPath: workspaceFilePath.string, contents: workspaceString.data(using: .utf8), attributes: nil)
    }
}
