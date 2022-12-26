//
//  AbstractTarget.swift
//
//
//  Created by WildCat on 12/26/22.
//

import FoundationExtension
import PathKit
import XcodeProj

extension AbstractTarget {
    enum FindTargetRootPathError: Error {
        case noneFile
    }

    static func findTargetRootPath(target: PBXNativeTarget, projectRoot: Path) throws -> Path {
        guard let sourceFiles = try target.sourcesBuildPhase()?.files else {
            throw FindTargetRootPathError.noneFile
        }
        let fileElements = sourceFiles.compactMap(\.file)

        let fullPaths = fileElements.compactMap { $0.filePathFromRoot() }

        if fullPaths.isEmpty {
            throw FindTargetRootPathError.noneFile
        }

        let commomPrefix = String.commonPrefix(strings: fullPaths)

        if commomPrefix == fullPaths[0], let targetNameIndex = commomPrefix.index(of: target.name) {
            let targetNameIndex = commomPrefix.index(targetNameIndex, offsetBy: target.name.count)
            let targetNamePrefix = String(commomPrefix[..<targetNameIndex])
            return Path(targetNamePrefix)
        }

        let defaultPath = Path(commomPrefix)

        return defaultPath
    }
}
