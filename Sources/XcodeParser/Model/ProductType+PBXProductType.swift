//
// ProductType+PBXProductType.swift
// Copyright (c) 2022 Daohan Chong
// MIT License.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the  Software), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED  AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import XcodeAbstraction
import XcodeProj

public extension ProductType {
    init(from pbxProductType: PBXProductType) {
        switch pbxProductType {
        case .application:
            self = .application
        case .framework:
            self = .framework
        case .staticFramework:
            self = .staticFramework
        case .xcFramework:
            self = .xcFramework
        case .dynamicLibrary:
            self = .dynamicLibrary
        case .staticLibrary:
            self = .staticLibrary
        case .bundle:
            self = .bundle
        case .unitTestBundle:
            self = .unitTestBundle
        case .uiTestBundle:
            self = .uiTestBundle
        case .appExtension:
            self = .appExtension
        case .extensionKitExtension:
            self = .extensionKitExtension
        case .commandLineTool:
            self = .commandLineTool
        case .watchApp:
            self = .watchApp
        case .watch2App:
            self = .watch2App
        case .watch2AppContainer:
            self = .watch2AppContainer
        case .watchExtension:
            self = .watchExtension
        case .watch2Extension:
            self = .watch2Extension
        case .tvExtension:
            self = .tvExtension
        case .messagesApplication:
            self = .messagesApplication
        case .messagesExtension:
            self = .messagesExtension
        case .stickerPack:
            self = .stickerPack
        case .xpcService:
            self = .xpcService
        case .ocUnitTestBundle:
            self = .ocUnitTestBundle
        case .xcodeExtension:
            self = .xcodeExtension
        case .instrumentsPackage:
            self = .instrumentsPackage
        case .intentsServiceExtension:
            self = .intentsServiceExtension
        case .onDemandInstallCapableApplication:
            self = .onDemandInstallCapableApplication
        case .metalLibrary:
            self = .metalLibrary
        case .driverExtension:
            self = .driverExtension
        case .systemExtension:
            self = .systemExtension
        default:
            self = .none
        }
    }
}
