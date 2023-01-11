//
// BazelRule+Rendering.swift
// Copyright (c) 2023 Daohan Chong and other XcodeMigrate authors.
// MIT License.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the  Software), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED  AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import BazelRenderingKit
import Foundation

extension BazelRule {
    var renderedRule: Rule {
        switch self {
        case let .swiftLibrary(name, srcs, deps, moduleName):
            return Rule(name: "swift_library")
                .attr(key: "name", value: name)
                .attr(key: "srcs", value: srcs)
                .attr(key: "deps", value: deps.sorted())
                .attr(key: "module_name", value: moduleName)
                .attr(key: "visibility", value: ["//visibility:public"])
        case let .swiftTest(name, srcs, deps, moduleName):
            return Rule(name: "swift_test")
                .attr(key: "name", value: name)
                .attr(key: "srcs", value: srcs)
                .attr(key: "deps", value: deps.sorted())
                .attr(key: "module_name", value: moduleName)
                .attr(key: "visibility", value: ["//visibility:public"])
        case let .iosApplication(name, deps, bundleID, infoplists, minimumOSVersion, deviceFamilies, resources):
            return Rule(name: "ios_application")
                .attr(key: "name", value: name)
                .attr(key: "deps", value: deps.sorted())
                .attr(key: "bundle_id", value: bundleID)
                .attr(key: "infoplists", value: infoplists)
                .attr(key: "minimum_os_version", value: minimumOSVersion)
                .attr(key: "families", value: deviceFamilies.map(\.rawValue))
                .attr(key: "resources", value: resources)
        case let .iosFramework(name, deps, bundleID, minimumOSVersion, deviceFamilies, infoPlists, resources):
            return Rule(name: "ios_framework")
                .attr(key: "name", value: name)
                .attr(key: "bundle_id", value: bundleID)
                .attr(key: "families", value: deviceFamilies.map(\.rawValue))
                .attr(key: "infoplists", value: infoPlists)
                .attr(key: "minimum_os_version", value: minimumOSVersion)
                .attr(key: "visibility", value: ["//visibility:public"])
                .attr(key: "deps", value: deps.sorted())
                .attr(key: "resources", value: resources)
        case let .iosUnitTest(name, data, deps, minimumOSVersion, env, platformType, runner, testFilter, testHost):
            return Rule(name: "ios_unit_test")
                .attr(key: "name", value: name)
                .attr(key: "data", value: data)
                .attr(key: "deps", value: deps.sorted())
                .attr(key: "minimum_os_version", value: minimumOSVersion)
                .attr(key: "env", value: env)
                .attr(key: "platform_type", value: platformType.rawValue)

        // TODO: Add support for runner, test_filter, and test_host
        // .attr(key: "runner", value: runner)
        // .attr(key: "test_filter", value: testFilter)
        // .attr(key: "test_host", value: testHost)
        case let .filegroup(name, srcs):
            return Rule(name: "filegroup")
                .attr(key: "name", value: name)
                .attr(key: "srcs", value: srcs)
                // TODO: Improve visibility (<https://github.com/XcodeMigrate/XcodeMigrate/issues/5>)
                .attr(key: "visibility", value: ["//visibility:public"])
        }
    }
}
