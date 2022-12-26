import PathKit
import XcodeAbstraction
import XcodeProj

public class XcodeParser {
    let project: XcodeProj

    let projectRoot: Path

    var abstractProject: AbstractProject?

    public init(projectPath: String) throws {
        let path = Path(projectPath)
        self.projectRoot = path.parent()
        self.project = try XcodeProj(path: path)
    }

    func perform() throws {
        let targets: [AbstractTarget] = try project.pbxproj.nativeTargets.compactMap { target -> AbstractTarget? in
            let name = target.name
            guard let productType = target.productType else {
                return nil
            }

            let targetPath = try! AbstractTarget.findTargetRootPath(target: target, projectRoot: projectRoot)

            let sourceBuildPhase = try target.sourcesBuildPhase()
            let filePathStrings: [String]? = sourceBuildPhase?.files?.compactMap { file in
                file.file?.path
            }

            let filePaths = (filePathStrings ?? []).map { Path($0) }

            return AbstractTarget(name: name, productType: ProductType(from: productType), path: targetPath, sourceFilePaths: filePaths)
        }

        self.abstractProject = AbstractProject(targets: targets)
    }
}

private extension XcodeParser {}
