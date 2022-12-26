import PathKit
import XcodeProj

public class XcodeParser {
    let project: XcodeProj
   
    var targets: [AbstractTarget]?
    
    public init(path: String) throws {
        project = try XcodeProj(path: Path(path))
    }

    func perform() {
        let projectDirPath = project.pbxproj.rootObject!.projectDirPath
        
        let targets = project.pbxproj.nativeTargets.compactMap { target in
            let name = target.name
            let productType = target.productType
           
       
            try! AbstractTarget.findTargetRootPath(target: target, projectDirPath: projectDirPath)
        }
    }
}

private extension XcodeParser {
    
}
