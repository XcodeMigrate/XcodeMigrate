//
//  AbstractProject.swift
//
//
//  Created by Daohan Chong on 12/26/22.
//

import Foundation

public struct AbstractProject {
    public let targets: [AbstractTarget]

    public init(targets: [AbstractTarget]) {
        self.targets = targets
    }
}
