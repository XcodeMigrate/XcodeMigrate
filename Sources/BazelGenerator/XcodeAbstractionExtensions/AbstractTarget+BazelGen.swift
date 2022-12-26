import FoundationExtension
import XcodeAbstraction

enum BazelGeneratorAbstractTargetError: Error {
    case unimplemented
}

extension AbstractTarget {
    func bazelGen() throws -> String {
        switch productType {
        case .framework:
            return generateSwiftLibrary()
        case .application:
            return generatePhoneOSApplication()
        case .unitTestBundle:
            fallthrough
        case .uiTestBundle:
            fallthrough
        default:
            throw BazelGeneratorAbstractTargetError.unimplemented
        }
    }
}

private extension AbstractTarget {
    func generateSwiftLibrary() -> String {
        let sourcePaths = sourceFiles.map { $0.path.string }

        return """
        swift_library(
            name = "\(name)",
            srcs = \(sourcePaths.toArrayLiteralString()),
            deps = \(dependencyLabels.toArrayLiteralString())
        )
        """
    }

    func generatePhoneOSApplication() -> String {
        let sourcePaths = sourceFiles.map { $0.path.string }

        return """
        ios_application(
            name = "\(name)",
            srcs = \(sourcePaths.toArrayLiteralString()),
            deps = \(dependencyLabels.toArrayLiteralString())
        )
        """
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
