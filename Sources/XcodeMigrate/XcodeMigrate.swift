import ArgumentParser
import BazelGenerator
import Common
import Foundation
import XcodeParser

let logger = Logger(label: "XcodeMigrate")

enum TopLevelCommand: String, ExpressibleByArgument {
    case bazel
}

@main
struct XcodeMigrate: ParsableCommand {
    @Argument(help: "Action to execute. Available action: bazel")
    var action: TopLevelCommand

    @Option(name: .shortAndLong, help: "Path to Xcode project")
    var project: String

    mutating func run() throws {
        logger.info("Project path: \(project)")
        let parser = try XcodeParser(projectPath: project)

        try parser.perform()

        guard let abstractProject = parser.abstractProject else {
            fatalError("Cannot parse project")
        }

        try BazelGenerator.generate(from: abstractProject)

        logger.info("Bazel project generated at: \(project)")
    }
}
