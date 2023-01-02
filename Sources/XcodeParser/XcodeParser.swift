//
// XcodeParser.swift
// Copyright (c) 2023 Daohan Chong and other XcodeMigrate authors.
// MIT License.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the  Software), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED  AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import Common
import PathKit
import XcodeAbstraction
import XcodeProj

let logger = Logger(label: "XcodeParser")

public class XcodeParser {
    let project: XcodeProj

    let projectRoot: Path

    public private(set) var abstractProject: AbstractProject?

    public init(projectPath: String) throws {
        let inputPath = Path(projectPath)
        let path = inputPath.isAbsolute ? inputPath : Path.current + inputPath

        projectRoot = path.parent()
        project = try XcodeProj(path: path)
    }

    public func perform() throws {
//        let targetMap: [String: AbstractTarget] = [:] // TODO: Memorize targets generated so far

        let targets: [AbstractTarget] = try project.pbxproj.nativeTargets.compactMap { target -> AbstractTarget? in
            try AbstractTarget(from: target, projectRoot: projectRoot)
        }

        abstractProject = AbstractProject(targets: targets, rootPath: projectRoot)
    }
}

private extension XcodeParser {}
