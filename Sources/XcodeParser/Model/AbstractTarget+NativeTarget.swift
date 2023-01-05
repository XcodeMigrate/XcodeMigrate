//
// AbstractTarget+NativeTarget.swift
// Copyright (c) 2023 Daohan Chong and other XcodeMigrate authors.
// MIT License.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the  Software), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED  AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import Common
import PathKit
import XcodeAbstraction
import XcodeProj

enum AbstractTargetCreationError: Error {
    case noInfoPlist
}

extension AbstractTarget {
    private enum Constants {
        static let infoPlistBuildSettingsKey = "INFOPLIST_FILE"
        static let iphoneOSDeploymentTargetKey = "IPHONEOS_DEPLOYMENT_TARGET"
        static let productBundleIdentifierKey = "PRODUCT_BUNDLE_IDENTIFIER"
        static let targetedDeviceFamilyKey = "TARGETED_DEVICE_FAMILY"
    }

    init?(
        from target: PBXNativeTarget,
        projectRoot: Path,
        configuration: ParserConfiguration
    ) throws {
        let name = target.name
        guard let productType = target.productType else {
            return nil
        }

        let targetPath = try! AbstractTarget.findTargetRootPath(target: target, projectRoot: projectRoot)
        let normalizedTargetPath: Path = {
            if targetPath.isAbsolute {
                return targetPath
            } else {
                return projectRoot + targetPath
            }
        }()

        let sourceBuildPhase = try target.sourcesBuildPhase()
        let sourceFiles: [AbstractSourceFile]? = sourceBuildPhase?.files?.compactMap { file in
            guard let fileElement = file.file else {
                return nil
            }
            guard let abstractFile = AbstractSourceFile(from: fileElement) else {
                return nil
            }

            return abstractFile
        }

        let nativeTargetDependencies = target.dependencies.compactMap { $0.target as? PBXNativeTarget }
        let dependencyTargets = try nativeTargetDependencies.compactMap { try AbstractTarget(from: $0, projectRoot: projectRoot, configuration: configuration) }

        let targetBuildSetting = configuration.buildConfig ?? "Debug"
        let selectedBuildConfiguration: XCBuildConfiguration?
        if let matchedConfiguration = target.buildConfigurationList?.buildConfigurations.first(where: { $0.name == targetBuildSetting }) {
            selectedBuildConfiguration = matchedConfiguration
        } else {
            logger.warning("No configuration found for name \(targetBuildSetting), using first configuration")
            selectedBuildConfiguration = target.buildConfigurationList?.buildConfigurations.first
        }

        guard let infoPlist =
            selectedBuildConfiguration?.buildSettings[Constants.infoPlistBuildSettingsKey] as? String
        else {
            throw AbstractTargetCreationError.noInfoPlist
        }
        let infoPlistPath = Path(components: [
            projectRoot.string,
            infoPlist,
        ])

        let iPhoneDeploymentTarget: String?
        if let iPhoneDeploymentTargetString = selectedBuildConfiguration?.buildSettings[Constants.iphoneOSDeploymentTargetKey] as? String {
            iPhoneDeploymentTarget = iPhoneDeploymentTargetString
        } else {
            iPhoneDeploymentTarget = nil
            logger.warning("Cannot find \(Constants.iphoneOSDeploymentTargetKey) for target \(name)")
        }

        let bundleID: String
        if let bundleIDFromBuildConfiguration = selectedBuildConfiguration?.buildSettings[Constants.productBundleIdentifierKey] as? String {
            bundleID = bundleIDFromBuildConfiguration
        } else {
            bundleID = "not.found.bundle.id.\(target.name)"
            logger.warning("Cannot find \(Constants.productBundleIdentifierKey) for target \(name), using \(bundleID)")
        }

        let deploymentTarget = DeploymentTarget(iOS: iPhoneDeploymentTarget)

        let targetDevice: TargetDevice
        if let targetedDeviceFamilyString = selectedBuildConfiguration?.buildSettings[Constants.targetedDeviceFamilyKey] as? String {
            let targetedDeviceInteger = targetedDeviceFamilyString.split(separator: ",").compactMap { UInt($0) }.reduce(0) { partialResult, newInteger in
                partialResult + newInteger
            }
            let parsedTargetDevice = TargetDevice(rawValue: targetedDeviceInteger)
            targetDevice = parsedTargetDevice
        } else {
            logger.warning("Cannot parse \(Constants.targetedDeviceFamilyKey), using .iphone")
            targetDevice = [.iphone]
        }

        self.init(
            name: name,
            productType: ProductType(from: productType),
            bundleIdentifier: bundleID,
            path: normalizedTargetPath,
            sourceFiles: sourceFiles ?? [],
            dependencies: dependencyTargets,
            infoPlistPath: infoPlistPath,
            deploymentTarget: deploymentTarget,
            targetDevice: targetDevice
        )
    }
}
