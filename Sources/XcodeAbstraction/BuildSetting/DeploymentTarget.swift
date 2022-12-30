//
//  DeploymentTarget.swift
//
//
//  Created by WildCat on 12/30/22.
//

import Foundation

public struct DeploymentTarget: Hashable {
    public var iOS: String?
    public var tvOS: String?
    public var watchOS: String?
    public var macOS: String?

    public init(iOS: String? = nil, tvOS: String? = nil, watchOS: String? = nil, macOS: String? = nil) {
        self.iOS = iOS
        self.tvOS = tvOS
        self.watchOS = watchOS
        self.macOS = macOS
    }
}
