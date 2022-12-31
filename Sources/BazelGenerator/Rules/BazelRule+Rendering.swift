import BazelRenderingKit
import Foundation

extension BazelRule {
    var renderedRule: Rule {
        switch self {
        case let .swiftLibrary(name, srcs, deps, moduleName):
            return Rule(name: "swift_library")
                .attr(key: "name", value: name)
                .attr(key: "srcs", value: srcs)
                .attr(key: "deps", value: deps)
                .attr(key: "module_name", value: moduleName)
                .attr(key: "visibility", value: ["//visibility:public"])
        case let .iosApplication(name, deps, infoplists, minimumOSVersion, deviceFamilies):
            return Rule(name: "ios_application")
                .attr(key: "name", value: name)
                .attr(key: "deps", value: deps)
                // TODO: Fix bundle id parsing (<https://github.com/XcodeMigrate/XcodeMigrate/issues/4>)
                .attr(key: "bundle_id", value: "demo.app.\(name)")
                .attr(key: "infoplists", value: infoplists)
                .attr(key: "minimum_os_version", value: minimumOSVersion)
                .attr(key: "families", value: deviceFamilies.map(\.rawValue))
        case let .iosFramework(name, deps, bundleID, minimumOSVersion, deviceFamilies, infoPlists):
            return Rule(name: "ios_framework")
                .attr(key: "name", value: name)
                .attr(key: "bundle_id", value: bundleID)
                .attr(key: "families", value: deviceFamilies.map(\.rawValue))
                .attr(key: "infoplists", value: infoPlists)
                .attr(key: "minimum_os_version", value: minimumOSVersion)
                .attr(key: "visibility", value: ["//visibility:public"])
                .attr(key: "deps", value: deps)
        case let .filegroup(name, srcs):
            return Rule(name: "filegroup")
                .attr(key: "name", value: name)
                .attr(key: "srcs", value: srcs)
                // TODO: Improve visibility (<https://github.com/XcodeMigrate/XcodeMigrate/issues/5>)
                .attr(key: "visibility", value: ["//visibility:public"])
        }
    }
}
