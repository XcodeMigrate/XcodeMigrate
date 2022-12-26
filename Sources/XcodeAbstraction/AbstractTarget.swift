//
//  AbstractTarget.swift
//
//
//  Created by WildCat on 12/24/22.
//

import Foundation
import PathKit
public struct AbstractTarget {
    let name: String
    let productType: ProductType
    let path: Path
    let sourceFilePaths: [Path]

    public init(name: String, productType: ProductType, path: Path, sourceFilePaths: [Path]) {
        self.name = name
        self.productType = productType
        self.path = path
        self.sourceFilePaths = sourceFilePaths
    }
}
