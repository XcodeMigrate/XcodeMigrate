import XcodeParser

@main
public struct XcodeMigrate {
    public private(set) var text = "Hello, World!"

    public static func main() {
        print(XcodeMigrate().text)
    }
}
