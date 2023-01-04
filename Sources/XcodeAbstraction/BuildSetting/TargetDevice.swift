//
//  File.swift
//  
//
//  Created by WildCat on 1/3/23.
//

import Foundation

public struct TargetDevice: OptionSet, Codable, Hashable {
    public static let iphone = TargetDevice(rawValue: 1 << 0)
    public static let ipad = TargetDevice(rawValue: 1 << 1)
    public static let mac = TargetDevice(rawValue: 1 << 2)

    public let rawValue: UInt

    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
}
