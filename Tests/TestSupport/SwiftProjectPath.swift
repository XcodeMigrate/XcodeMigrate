import Foundation

public enum SwiftProjectPath {}

public extension SwiftProjectPath {
    static func projectFolder() -> String {
        let filePath = #file
        let projectFolder = filePath.components(separatedBy: "/Tests/").first!
        return projectFolder
    }
}
