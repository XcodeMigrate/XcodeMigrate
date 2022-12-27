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
        path + "BUILD.bazel"
    }
}

extension AbstractTarget {
    func generateRules() throws -> [BazelRule] {
        switch productType {
        case .framework:
            return generateFramework()
        case .application:
            return generatePhoneOSApplication()
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
    func generateFramework() -> [BazelRule] {
        let prefixString = path.string
        let sourcePaths = sourceFiles.map { sourceFile in
            sourceFile.path.string.removePrefix(prefix: prefixString).removePrefix(prefix: "/")
        }

        return [
            .swiftLibrary(name: name, srcs: sourcePaths, deps: dependencyLabels),
        ]
    }

    func generatePhoneOSApplication() -> [BazelRule] {
        let prefixString = path.string
        let sourcePaths = sourceFiles.map { $0.path.string.removePrefix(prefix: prefixString).removePrefix(prefix: "/") }

        let sourceName = "\(name)_source"
        let mainTargetSource: BazelRule = .swiftLibrary(name: sourceName, srcs: sourcePaths, deps: dependencyLabels)

        return [
            .iosApplication(name: name, deps: [
                ":\(sourceName)",
            ]),
            mainTargetSource,
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
