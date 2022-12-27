import Foundation
import PathKit
import XcodeAbstraction

public enum BazelGenerator {}

public extension BazelGenerator {
    static func generate(from project: AbstractProject) throws {
        let fileManager = FileManager.default

        // Create BUILD files

        var ruleSets: Set<BazelRuleSet> = []
        for target in project.targets {
            guard let generatedRules = try? target.generateRules() else {
                // TODO: Test all supported product types
                continue
            }
            var ruleStrings: [String] = []
            for generatedRule in generatedRules {
                ruleSets.insert(generatedRule.ruleSet)

                ruleStrings.append(generatedRule.generatedRuleString)
            }

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

            fileManager.createFile(atPath: normalizedBuildFilePath.string, contents: ruleStrings.joined(separator: "\n").data(using: .utf8), attributes: nil)
        }

        // Create WORKSPACE
        let workspaceRuleSetStrings = ruleSets.map(\.workspaceContent)

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
