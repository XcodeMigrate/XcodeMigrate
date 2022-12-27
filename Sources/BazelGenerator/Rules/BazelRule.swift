import XcodeAbstraction

@frozen enum BazelRule {
    case swiftLibrary(name: String, srcs: [String], deps: [String])
    case iosApplication(name: String, srcs: [String], deps: [String])
}

extension BazelRule {
    var ruleSet: BazelRuleSet {
        switch self {
        case .swiftLibrary:
            return .swift
        case .iosApplication:
            return .apple
        }
    }
}

extension BazelRule {
    var generatedRuleString: String {
        switch self {
        case let .swiftLibrary(name, srcs, deps):
            return """
            swift_library(
                name = "\(name)",
                srcs = \(srcs.toArrayLiteralString()),
                deps = \(deps.toArrayLiteralString())
            )
            """
        case let .iosApplication(name, srcs, deps):
            return """
            ios_application(
                name = "\(name)",
                srcs = \(srcs.toArrayLiteralString()),
                deps = \(deps.toArrayLiteralString())
            )
            """
        }
    }
}
