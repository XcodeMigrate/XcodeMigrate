//
//  AbstractTarget.swift
//
//
//  Created by Daohan Chong on 12/24/22.
//

import Foundation
import PathKit
public struct AbstractTarget {
    public let name: String
    public let productType: ProductType
    public let path: Path
    public let sourceFiles: [AbstractSourceFile]
    public let dependencies: [AbstractTarget]

    public init(name: String, productType: ProductType, path: Path, sourceFiles: [AbstractSourceFile], dependencies: [AbstractTarget]) {
        self.name = name
        self.productType = productType
        self.path = path
        self.sourceFiles = sourceFiles
        self.dependencies = dependencies
    }
}
