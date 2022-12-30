//
//  DeploymentTarget.swift
//
//
//  Created by WildCat on 12/30/22.
//

import Foundation

public struct DeploymentTarget: Hashable {
    public var iOS: String?

    public init(iOS: String? = nil) {
        self.iOS = iOS
    }
}
