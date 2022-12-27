//
//  File.swift
//
//
//  Created by WildCat on 12/26/22.
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
    }

    init?(from target: PBXNativeTarget, projectRoot: Path) throws {
        let name = target.name
        guard let productType = target.productType else {
            return nil
        }

        let targetPath = try! AbstractTarget.findTargetRootPath(target: target, projectRoot: projectRoot)

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

        guard let infoPlist = target.buildConfigurationList?.buildConfigurations.first?.buildSettings[Constants.infoPlistBuildSettingsKey] as? String else {
            throw AbstractTargetCreationError.noInfoPlist
        }
        let infoPlistPath = Path(components: [
            projectRoot.string,
            infoPlist,
        ])

        self.init(name: name, productType: ProductType(from: productType), path: targetPath, sourceFiles: sourceFiles ?? [], dependencies: dependencyTargets, infoPlistPath: infoPlistPath)
    }
}
