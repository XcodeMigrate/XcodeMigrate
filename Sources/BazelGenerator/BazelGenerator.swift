import XcodeAbstraction

public enum BazelGenerator {}

public extension BazelGenerator {
    static func generate(from project: AbstractProject) -> String {
        let targets = project.targets.map { target in
      """
      \(target.name)_target(
          name = "\(target.name)",
          srcs = glob(["**/*.swift"]),
          deps = [
              "//\(target.name):\(target.name)_module",
          ],
      )
      """
        }
        return targets.joined(separator: "")
    }
}


