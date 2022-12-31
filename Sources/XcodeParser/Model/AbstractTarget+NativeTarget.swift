//
// AbstractTarget+NativeTarget.swift
// Copyright (c) 2022 Daohan Chong
// MIT License.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the  Software), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED  AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

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
    }

    init?(from target: PBXNativeTarget, projectRoot: Path) throws {
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
        let dependencyTargets = try nativeTargetDependencies.compactMap { try AbstractTarget(from: $0, projectRoot: projectRoot) }

        guard let infoPlist =
            // TODO: Add configuration for parsing Debug/Release builds (https://github.com/XcodeMigrate/XcodeMigrate/issues/19)
            target.buildConfigurationList?.buildConfigurations.first?.buildSettings[Constants.infoPlistBuildSettingsKey] as? String
        else {
            throw AbstractTargetCreationError.noInfoPlist
        }
        let infoPlistPath = Path(components: [
            projectRoot.string,
            infoPlist,
        ])

        let iPhoneDeploymentTarget: String?
        // TODO: Add configuration for parsing Debug/Release builds (https://github.com/XcodeMigrate/XcodeMigrate/issues/19)
        if let iPhoneDeploymentTargetString = target.buildConfigurationList?.buildConfigurations.first?.buildSettings[Constants.iphoneOSDeploymentTargetKey] as? String {
            iPhoneDeploymentTarget = iPhoneDeploymentTargetString
        } else {
            iPhoneDeploymentTarget = nil
            logger.warning("Cannot find \(Constants.iphoneOSDeploymentTargetKey) for target \(name)")
        }
        let deploymentTarget = DeploymentTarget(iOS: iPhoneDeploymentTarget)

        self.init(
            name: name,
            productType: ProductType(from: productType),
            path: normalizedTargetPath,
            sourceFiles: sourceFiles ?? [],
            dependencies: dependencyTargets,
            infoPlistPath: infoPlistPath,
            deploymentTarget: deploymentTarget
        )
    }
}
