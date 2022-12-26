//
//  File.swift
//  
//
//  Created by WildCat on 12/24/22.
//

import Foundation
import enum XcodeProj.PBXProductType
import PathKit

struct AbstractTarget {
    let name: String
    let productType: XcodeProj.PBXProductType
    let path: Path
    let sourceFilePaths: [Path]
    
    init(name: String, productType: XcodeProj.PBXProductType, path: Path, sourceFilePaths: [Path]) {
        self.name = name
        self.productType = productType
        self.path = path
        self.sourceFilePaths = sourceFilePaths
    }
}

