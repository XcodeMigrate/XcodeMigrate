//
//  File.swift
//
//
//  Created by WildCat on 12/26/22.
//

import PathKit
import XcodeAbstraction
import XcodeProj

extension AbstractSourceFile {
    init?(from fileElement: PBXFileElement) {
        guard let fullPath = Self.expandFullPath(fileElement: fileElement) else {
            return nil
        }

        self.init(path: Path(fullPath))
    }
}

private extension AbstractSourceFile {
    static func expandFullPath(fileElement: PBXFileElement) -> String? {
        guard let filePath = fileElement.path else {
            return nil
        }
        guard let parent = fileElement.parent else {
            return filePath
        }

        return [expandFullPath(fileElement: parent), filePath].compactMap { $0 }.joined(separator: "/")
    }
}
