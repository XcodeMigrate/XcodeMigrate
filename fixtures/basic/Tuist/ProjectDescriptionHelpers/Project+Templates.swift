//
// Project+Templates.swift
// Copyright (c) 2022 Daohan Chong
// MIT License.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the  Software), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED  AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import ProjectDescription

/// Project helpers are functions that simplify the way you define your project.
/// Share code to create targets, settings, dependencies,
/// Create your own conventions, e.g: a func that makes sure all shared targets are "static frameworks"
/// See https://docs.tuist.io/guides/helpers/

extension Project {
    private enum Constants {
        static let deploymentTarget: DeploymentTarget = .iOS(targetVersion: "13.0", devices: [.iphone, .ipad])
    }

    /// Helper function to create the Project for this ExampleApp
    public static func app(name: String, platform: Platform, additionalTargets: [String]) -> Project {
        var targets = makeAppTargets(name: name,
                                     platform: platform,
                                     dependencies: additionalTargets.map { TargetDependency.target(name: $0) })
        targets += additionalTargets.flatMap { makeFrameworkTargets(name: $0, platform: platform) }
        return Project(name: name,
                       organizationName: "tuist.io",
                       targets: targets)
    }

    // MARK: - Private

    /// Helper function to create a framework target and an associated unit test target
    private static func makeFrameworkTargets(name: String, platform: Platform) -> [Target] {
        let sources = Target(name: name,
                             platform: platform,
                             product: .framework,
                             bundleId: "io.tuist.\(name)",
                             deploymentTarget: Constants.deploymentTarget,
                             infoPlist: .default,
                             sources: ["Targets/\(name)/Sources/**"],
                             resources: [],
                             dependencies: [])
        let tests = Target(name: "\(name)Tests",
                           platform: platform,
                           product: .unitTests,
                           bundleId: "io.tuist.\(name)Tests",
                           deploymentTarget: Constants.deploymentTarget,
                           infoPlist: .default,
                           sources: ["Targets/\(name)/Tests/**"],
                           resources: [],
                           dependencies: [.target(name: name)])
        return [sources, tests]
    }

    /// Helper function to create the application target and the unit test target.
    private static func makeAppTargets(name: String, platform: Platform, dependencies: [TargetDependency]) -> [Target] {
        let platform: Platform = platform
        let infoPlist: [String: InfoPlist.Value] = [
            "CFBundleShortVersionString": "1.0",
            "CFBundleVersion": "1",
            "UIMainStoryboardFile": "",
            "UILaunchStoryboardName": "LaunchScreen",
        ]

        let mainTarget = Target(
            name: name,
            platform: platform,
            product: .app,
            bundleId: "io.tuist.\(name)",
            deploymentTarget: Constants.deploymentTarget,
            infoPlist: .extendingDefault(with: infoPlist),
            sources: ["Targets/\(name)/Sources/**"],
            resources: ["Targets/\(name)/Resources/**"],
            dependencies: dependencies
        )

        let testTarget = Target(
            name: "\(name)Tests",
            platform: platform,
            product: .unitTests,
            bundleId: "io.tuist.\(name)Tests",
            deploymentTarget: Constants.deploymentTarget,
            infoPlist: .default,
            sources: ["Targets/\(name)/Tests/**"],
            dependencies: [
                .target(name: "\(name)"),
            ]
        )
        return [mainTarget, testTarget]
    }
}
