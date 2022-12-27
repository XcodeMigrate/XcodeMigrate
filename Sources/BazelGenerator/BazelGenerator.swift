import Foundation
import XcodeAbstraction

public enum BazelGenerator {}

public extension BazelGenerator {
    static func generate(from project: AbstractProject) throws {
        let fileManager = FileManager.default
        // Create WORKSPACE

        // Create BUILD files

        for target in project.targets {
            let generatedRules = try target.bazelGen()

            let buildFilePath = target.buildFilePath()

            if fileManager.fileExists(atPath: buildFilePath.string) {
                try fileManager.removeItem(at: buildFilePath.url)
            }

            try generatedRules.write(to: buildFilePath.url, atomically: true, encoding: .utf8)
        }
    }
}
