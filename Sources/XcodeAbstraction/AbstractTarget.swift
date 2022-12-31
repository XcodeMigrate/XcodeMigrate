//
// AbstractTarget.swift
// Copyright (c) 2022 Daohan Chong
// MIT License.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the  Software), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED  AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import Foundation
import PathKit
public struct AbstractTarget {
    public let name: String
    public let productType: ProductType
    public let path: Path
    public let sourceFiles: [AbstractSourceFile]
    public let dependencies: [AbstractTarget]
    public let infoPlistPath: Path
    public let deploymentTarget: DeploymentTarget

    public init(name: String, productType: ProductType, path: Path, sourceFiles: [AbstractSourceFile], dependencies: [AbstractTarget], infoPlistPath: Path, deploymentTarget: DeploymentTarget) {
        self.name = name
        self.productType = productType
        self.path = path
        self.sourceFiles = sourceFiles
        self.dependencies = dependencies
        self.infoPlistPath = infoPlistPath
        self.deploymentTarget = deploymentTarget
    }
}
