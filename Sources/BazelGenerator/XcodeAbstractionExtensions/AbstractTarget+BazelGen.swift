import FoundationExtension
import PathKit
import XcodeAbstraction

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
    func buildFilePath() -> Path {
        return path + "BUILD.bazel"
    }
}

extension AbstractTarget {
    func generateRules(rootPath: Path) throws -> [CreateBuildFileOperation] {
        switch productType {
        case .framework:
            return generateFramework(rootPath: rootPath)
        case .application:
            return generatePhoneOSApplication(rootPath: rootPath)
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
    func generateFramework(rootPath: Path) -> [CreateBuildFileOperation] {
        let prefixString = path.string
        let sourcePaths = sourceFiles.map { sourceFile in
            sourceFile.path.string.removePrefix(prefix: prefixString).removePrefix(prefix: "/")
        }

        let infoPlistDirectory = Path(infoPlistPath.url.deletingLastPathComponent().path)
        let infoPlistBuildFilePath = infoPlistDirectory + "BUILD.bazel"

        let swiftLibraryName = "\(name)_lib"

        let infoPlistLabel = "\(name)_InfoPlist"

        let infoPlistLabelFromCurrentTarget = "/" + infoPlistDirectory.string.removePrefix(prefix: rootPath.string) + ":\(infoPlistLabel)"

        return [
            CreateBuildFileOperation(targetPath: buildFilePath(), rules: [
                .swiftLibrary(name: name, srcs: sourcePaths, deps: dependencyLabels),
                .iosFramework(name: name, deps: [":\(swiftLibraryName)"], bundleID: "to.do.\(name)", minimumOSVersion: "13.0", deviceFamilies: [.iphone], infoPlists: [infoPlistLabelFromCurrentTarget]),
            ]),
            CreateBuildFileOperation(targetPath: infoPlistBuildFilePath, rules: [
                .filegroup(name: infoPlistLabel, srcs: [
                    infoPlistPath.string.removePrefix(prefix: infoPlistDirectory.string),
                ]),
            ]),
        ]
    }

    func generatePhoneOSApplication(rootPath: Path) -> [CreateBuildFileOperation] {
        let prefixString = path.string
        let sourcePaths = sourceFiles.map { $0.path.string.removePrefix(prefix: prefixString).removePrefix(prefix: "/") }

        let sourceName = "\(name)_source"
        let mainTargetSource: BazelRule = .swiftLibrary(name: sourceName, srcs: sourcePaths, deps: dependencyLabels)

        let infoPlistDirectory = Path(infoPlistPath.url.deletingLastPathComponent().path)
        let infoPlistBuildFilePath = infoPlistDirectory + "BUILD.bazel"

        let infoPlistLabel = "\(name)_InfoPlist"

        let infoPlistLabelFromCurrentTarget = "/" + infoPlistDirectory.string.removePrefix(prefix: rootPath.string) + ":\(infoPlistLabel)"

        return [
            CreateBuildFileOperation(targetPath: path, rules: [
                .iosApplication(name: name, deps: [
                    ":\(sourceName)",
                ],
                infoplists: [infoPlistLabelFromCurrentTarget]),
                mainTargetSource,
            ]),
            CreateBuildFileOperation(targetPath: infoPlistBuildFilePath, rules: [
            ]),
        ]
    }
}

private extension AbstractTarget {
    var dependencyLabels: [String] {
        return dependencies.map { dependency in
            let commonPathPrefix = String.commonPrefix(strings: [
                self.path.string,
                dependency.path.string,
            ])
            let dependencyLabelWithOutCommonPath = dependency.path.string[commonPathPrefix.endIndex...]
            return "//\(dependencyLabelWithOutCommonPath)"
        }
    }
}
