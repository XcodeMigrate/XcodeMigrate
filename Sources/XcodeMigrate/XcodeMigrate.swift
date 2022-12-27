import Common
import XcodeParser

let logger = Logger(label: "XcodeMigrate")

@main
public struct XcodeMigrate {
    public private(set) var text = "Hello, World!"

    public static func main() {
        logger.info("\(XcodeMigrate().text)")
    }
}
