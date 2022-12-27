//
//  AbstractProject.swift
//
//
//  Created by Daohan Chong on 12/26/22.
//

import Foundation
import PathKit

public struct AbstractProject {
    public let targets: [AbstractTarget]
    public let rootPath: Path
    
    public init(targets: [AbstractTarget], rootPath: Path) {
        self.targets = targets
        self.rootPath = rootPath
    }
}
