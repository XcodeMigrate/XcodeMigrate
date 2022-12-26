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
            fallthrough
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
        let sourcePaths = sourceFile.map { $0.path.string }

        return """
        swift_library(
            name = "\(name)",
            srcs = \(sourcePaths.toArrayLiteralString())
        )
        """
    }
}
