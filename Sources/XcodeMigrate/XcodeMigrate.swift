//
// XcodeMigrate.swift
// Copyright (c) 2023 Daohan Chong and other XcodeMigrate authors.
// MIT License.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the  Software), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED  AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

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

        let generatorConfig = GeneratorConfig(formatCode: true)
        try BazelGenerator.generate(from: abstractProject, config: generatorConfig)

        logger.info("Bazel project generated at: \(project)")
    }
}
