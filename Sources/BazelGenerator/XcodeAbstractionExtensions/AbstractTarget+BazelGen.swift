//
// AbstractTarget+BazelGen.swift
// Copyright (c) 2023 Daohan Chong and other XcodeMigrate authors.
// MIT License.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the  Software), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED  AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import Common
import FoundationExtension
import PathKit
import XcodeAbstraction

private enum AbstractTargetBazelGenConstants {
    static let frameworkLibSuffix = "_lib"
}

enum BazelGeneratorAbstractTargetError: Error {
    case unimplemented(productType: ProductType)

    var localizedDescription: String {
        switch self {
        case let .unimplemented(productType):
            return "Unimplemented Bazel generation for product type: \(productType)"
        }
    }
}

extension AbstractTarget {
    func buildFilePath(projectRoot: Path) -> Path {
        let buildFilePath = path + "BUILD.bazel"
        guard !buildFilePath.isAbsolute else {
            return buildFilePath
        }

        let normalizedBuildFilePath = projectRoot + buildFilePath
        return normalizedBuildFilePath
    }
}

extension AbstractTarget {
    func generateBazelFileCreateOperations(projectRoot: Path) throws -> [CreateBuildFileOperation] {
        switch productType {
        case .framework:
            return generateFramework(projectRoot: projectRoot)
        case .application:
            return generatePhoneOSApplication(projectRoot: projectRoot)
        case .unitTestBundle:
            fallthrough
        case .uiTestBundle:
            fallthrough
        default:
            throw BazelGeneratorAbstractTargetError.unimplemented(productType: productType)
        }
    }
}

private extension AbstractTarget {
    func generateFramework(projectRoot: Path) -> [CreateBuildFileOperation] {
        let infoPlistDirectory = Path(infoPlistPath.url.deletingLastPathComponent().path)
        let infoPlistBuildFilePath = infoPlistDirectory + "BUILD.bazel"

        let swiftLibraryName = "\(name)\(AbstractTargetBazelGenConstants.frameworkLibSuffix)"

        let infoPlistLabel = "\(name)_InfoPlist"

        let infoPlistLabelFromCurrentTarget = "/" + infoPlistDirectory.string.removePrefix(prefix: projectRoot.string) + ":\(infoPlistLabel)"

        return [
            CreateBuildFileOperation(targetPath: buildFilePath(projectRoot: projectRoot), rules: [
                .swiftLibrary(name: swiftLibraryName, srcs: sourcePathStrings(projectRoot: projectRoot), deps: dependencyLabels, moduleName: name),
                .iosFramework(name: name,
                              deps: [":\(swiftLibraryName)"], // TODO: Normalize Path: <https://github.com/XcodeMigrate/XcodeMigrate/issues/6>
                              bundleID: bundleIdentifier,
                              minimumOSVersion: deploymentTarget.iOS ?? "13.0",
                              deviceFamilies: deviceFamilies,
                              infoPlists: [infoPlistLabelFromCurrentTarget],
                              resources: resourceLabels(projectRoot: projectRoot)), // TODO: Normalize Path: <https://github.com/XcodeMigrate/XcodeMigrate/issues/6>
            ]),
            CreateBuildFileOperation(targetPath: infoPlistBuildFilePath, rules: [
                .filegroup(name: infoPlistLabel, srcs: [
                    infoPlistPath.string.removePrefix(prefix: infoPlistDirectory.string).removePrefix(prefix: "/"), // TODO: better path handling (<https://github.com/XcodeMigrate/XcodeMigrate/issues/6>)
                ]),
            ]),
        ]
    }

    func generatePhoneOSApplication(projectRoot: Path) -> [CreateBuildFileOperation] {
        let sourceName = "\(name)_source"
        let mainTargetSource: BazelRule = .swiftLibrary(
            name: sourceName,
            srcs: sourcePathStrings(projectRoot: projectRoot),
            deps: dependencyLabels.map { dependencyLabel in
                dependencyLabel + AbstractTargetBazelGenConstants.frameworkLibSuffix
            },
            moduleName: name
        )

        let infoPlistDirectory = Path(infoPlistPath.url.deletingLastPathComponent().path)
        let infoPlistBuildFilePath = infoPlistDirectory + "BUILD.bazel"

        let infoPlistLabel = "\(name)_InfoPlist"

        let infoPlistLabelFromCurrentTarget = "/" + infoPlistDirectory.string.removePrefix(prefix: projectRoot.string) + ":\(infoPlistLabel)"

        let applicationBuildFilePath = path + "BUILD.bazel"

        return [
            CreateBuildFileOperation(targetPath: applicationBuildFilePath, rules: [
                .iosApplication(
                    name: name,
                    deps: [
                        ":\(sourceName)",
                    ] + dependencyLabels, // TODO: Normalize Path: <https://github.com/XcodeMigrate/XcodeMigrate/issues/6>
                    bundleID: bundleIdentifier,
                    infoplists: [infoPlistLabelFromCurrentTarget],
                    minimumOSVersion: deploymentTarget.iOS ?? "13.0",
                    deviceFamilies: deviceFamilies,
                    resources: resourceLabels(projectRoot: projectRoot)
                ),
                mainTargetSource,
            ]),
            CreateBuildFileOperation(targetPath: infoPlistBuildFilePath, rules: [
                .filegroup(name: infoPlistLabel, srcs: [
                    infoPlistPath.string.removePrefix(prefix: infoPlistDirectory.string).removePrefix(prefix: "/"),
                ]),
            ]),
        ]
    }
}

private extension AbstractTarget {
    var dependencyLabels: [String] {
        dependencies.map { dependency in
            let commonPathPrefix = String.commonPrefix(strings: [
                self.path.string,
                dependency.path.string,
            ])
            let dependencyLabelWithOutCommonPath = dependency.path.string[commonPathPrefix.endIndex...]
            return "/\(dependencyLabelWithOutCommonPath):\(dependency.name)"
        }
    }

    var deviceFamilies: [BazelRule.DeviceFamily] {
        var families: [BazelRule.DeviceFamily] = []
        if targetDevice.contains(.iphone) {
            families.append(.iphone)
        }
        if targetDevice.contains(.ipad) {
            families.append(.ipad)
        }
        return families
    }

    func resourceLabels(projectRoot: Path) -> [String] {
        resources.map { resourceFile in
            resourceFile.path.isAbsolute ? resourceFile.path : (projectRoot + resourceFile.path)
        }.map { resourcePath in
            resourcePath.relative(to: normalizedTargetRootPath(projectRoot: projectRoot)).string
        }
    }

    func normalizedTargetRootPath(projectRoot: Path) -> Path {
        path.isAbsolute ? path : (projectRoot + path)
    }

    func sourcePathStrings(projectRoot: Path) -> [String] {
        sourceFiles.map { sourceFile in
            sourceFile.path.isAbsolute ? sourceFile.path : (projectRoot + sourceFile.path)
        }.map { sourcePath in
            sourcePath.relative(to: normalizedTargetRootPath(projectRoot: projectRoot)).string
        }
    }
}
