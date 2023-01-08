//
// BazelGenerator.swift
// Copyright (c) 2023 Daohan Chong and other XcodeMigrate authors.
// MIT License.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the  Software), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED  AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import Common
import Foundation
import PathKit
import XcodeAbstraction

let logger = Logger(label: "BazelGenerator")

public enum BazelGenerator {}

public extension BazelGenerator {
    static func generate(from project: AbstractProject, config: GeneratorConfig) throws {
        var formatterPath = findBuildifierPath()
        if formatterPath == nil, config.formatCode {
            logger.warning("buildifier is not installed. Please install it using `brew install buildifier`")
        } else if formatterPath != nil, !config.formatCode {
            formatterPath = nil
        }

        let fileManager = FileManager.default
        var globalRuleSet: Set<BazelRuleSet> = []
        var buildFileOperations: [Path: [CreateBuildFileOperation]] = [:]

        for target in project.targets {
            guard let createBuildFileOperations = try? target.generateBazelFileCreateOperations(projectRoot: project.rootPath) else {
                // TODO: Test all supported product types
                logger.critical("Failed to generate Bazel file for target: \(target.name) because of unsupported product type: \(target.productType)")
                continue
            }
            for operation in createBuildFileOperations {
                for generatedRule in operation.rules {
                    globalRuleSet.insert(generatedRule.ruleSet)
                }

                buildFileOperations[operation.targetPath, default: []].append(operation)
            }
        }

        let workspaceRuleSetStrings = Array(globalRuleSet).sorted(by: { a, b in
            a.rawValue < b.rawValue
        }).map(\.workspaceContent)

        let httpArchive = """
        load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
        """
        let workspaceString = httpArchive + "\n" + workspaceRuleSetStrings.joined(separator: "\n")

        let workspaceFilePath = project.rootPath + "WORKSPACE"

        if fileManager.fileExists(atPath: workspaceFilePath.string) {
            try fileManager.removeItem(at: workspaceFilePath.url)
        }

        fileManager.createFile(atPath: workspaceFilePath.string, contents: workspaceString.data(using: .utf8), attributes: nil)
        if let formatterPath {
            invokeFormatter(buildifierPath: formatterPath, filePath: workspaceFilePath.string)
        }

        try generateBuildFiles(fileManager: fileManager, operationMapping: buildFileOperations, formatterPath: formatterPath)
    }
}

private extension BazelGenerator {
    static func generateBuildFiles(fileManager: FileManager, operationMapping: [Path: [CreateBuildFileOperation]], formatterPath: Path?) throws {
        for (path, operations) in operationMapping {
            let mergedRuleLoadingStatements = CreateBuildFileOperation.aggregatedLoadingStatements(of: operations).joined(separator: "\n")
            let allRules = operations.map(\.allRules).sorted().joined(separator: "\n")

            if fileManager.fileExists(atPath: path.string) {
                try fileManager.removeItem(atPath: path.string)
            }

            let fullContent = mergedRuleLoadingStatements + "\n" + allRules

            fileManager.createFile(atPath: path.string, contents: fullContent.data(using: .utf8))

            if let formatterPath {
                invokeFormatter(buildifierPath: formatterPath, filePath: path.string)
            }
        }
    }

    static func invokeFormatter(buildifierPath: Path, filePath: String) {
        let process = Process()
        process.launchPath = buildifierPath.string
        process.arguments = [filePath]
        process.launch()
        process.waitUntilExit()
    }

    static func findBuildifierPath() -> Path? {
        if let path = ProcessInfo.processInfo.environment["PATH"] {
            let paths = path.split(separator: ":")
            for path in paths {
                let buildifierPath = Path(String(path)) + "buildifier"
                if buildifierPath.exists {
                    return buildifierPath
                }
            }
        }
        return nil
    }
}
