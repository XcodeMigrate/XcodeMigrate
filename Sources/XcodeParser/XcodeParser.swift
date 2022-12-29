import PathKit
import XcodeAbstraction
import XcodeProj

public class XcodeParser {
    let project: XcodeProj

    let projectRoot: Path

    public private(set) var abstractProject: AbstractProject?

    public init(projectPath: String) throws {
        let inputPath = Path(projectPath)
        let path = inputPath.isAbsolute ? inputPath : Path.current + inputPath

        projectRoot = path.parent()
        project = try XcodeProj(path: path)
    }

    public func perform() throws {
//        let targetMap: [String: AbstractTarget] = [:] // TODO: Memorize targets generated so far

        let targets: [AbstractTarget] = try project.pbxproj.nativeTargets.compactMap { target -> AbstractTarget? in
            try AbstractTarget(from: target, projectRoot: projectRoot)
        }

        abstractProject = AbstractProject(targets: targets, rootPath: projectRoot)
    }
}

private extension XcodeParser {}
