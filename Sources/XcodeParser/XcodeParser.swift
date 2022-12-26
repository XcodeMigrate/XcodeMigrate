import PathKit
import XcodeAbstraction
import XcodeProj

public class XcodeParser {
    let project: XcodeProj

    let projectRoot: Path

    var abstractProject: AbstractProject?

    public init(projectPath: String) throws {
        let path = Path(projectPath)
        projectRoot = path.parent()
        project = try XcodeProj(path: path)
    }

    func perform() throws {
        let targets: [AbstractTarget] = try project.pbxproj.nativeTargets.compactMap { target -> AbstractTarget? in
            let name = target.name
            guard let productType = target.productType else {
                return nil
            }

            let targetPath = try! AbstractTarget.findTargetRootPath(target: target, projectRoot: projectRoot)

            let sourceBuildPhase = try target.sourcesBuildPhase()
            let sourceFiles: [AbstractSourceFile]? = sourceBuildPhase?.files?.compactMap { file in
                guard let fileElement = file.file else {
                    return nil
                }
                guard let abstractFile = AbstractSourceFile(from: fileElement) else {
                    return nil
                }

                return abstractFile
            }

            return AbstractTarget(name: name, productType: ProductType(from: productType), path: targetPath, sourceFile: sourceFiles ?? [])
        }

        abstractProject = AbstractProject(targets: targets)
    }
}

private extension XcodeParser {}
