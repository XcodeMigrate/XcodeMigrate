//
//  File.swift
//
//
//  Created by WildCat on 12/26/22.
//

import XcodeProj

extension PBXFileElement {
    func filePathFromRoot() -> String? {
        guard let path = path else {
            return nil
        }
        guard let parent = parent else {
            return path
        }
        guard let parentPath = parent.filePathFromRoot() else {
            return path
        }
        return parentPath + "/" + path
    }
}
