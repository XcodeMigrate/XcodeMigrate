import Foundation
import PathKit
import XcodeAbstraction

public enum BazelGenerator {}

public extension BazelGenerator {
    static func generate(from project: AbstractProject) throws {
        let fileManager = FileManager.default
        // Create WORKSPACE

        // Create BUILD files

        for target in project.targets {
            guard let generatedRules = try? target.bazelGen() else {
                // TODO: Test all supported product types
                continue
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

            fileManager.createFile(atPath: normalizedBuildFilePath.string, contents: nil, attributes: nil)
            try generatedRules.write(to: buildFilePath.url, atomically: true, encoding: .utf8)
        }
    }
}
