//
// AbstractTarget+FindRootPath.swift
// Copyright (c) 2023 Daohan Chong and other XcodeMigrate authors.
// MIT License.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the  Software), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED  AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import FoundationExtension
import PathKit
import XcodeAbstraction
import XcodeProj

extension AbstractTarget {
    enum FindTargetRootPathError: Error {
        case noneFile
    }

    static func findTargetRootPath(target: PBXNativeTarget, projectRoot _: Path) throws -> Path {
        guard let sourceFiles = try target.sourcesBuildPhase()?.files else {
            throw FindTargetRootPathError.noneFile
        }
        let fileElements = sourceFiles.compactMap(\.file)

        let fullPaths = fileElements.compactMap { $0.filePathFromRoot() }

        if fullPaths.isEmpty {
            throw FindTargetRootPathError.noneFile
        }

        let commonPrefix = String.commonPrefix(strings: fullPaths)

        if commonPrefix == fullPaths[0], let targetNameIndex = commonPrefix.index(of: target.name) {
            let targetNameIndex = commonPrefix.index(targetNameIndex, offsetBy: target.name.count)
            let targetNamePrefix = String(commonPrefix[..<targetNameIndex])
            return Path(targetNamePrefix)
        }

        let defaultPath = Path(commonPrefix)

        return defaultPath
    }
}
