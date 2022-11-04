import XcodeParser

@main
public struct BazelGen {
    public private(set) var text = "Hello, World!"

    public static func main() {
        print(BazelGen().text)
    }
}
