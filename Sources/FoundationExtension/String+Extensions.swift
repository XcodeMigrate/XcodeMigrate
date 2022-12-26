import Foundation

public extension String {
    static func commonPrefix(strings: [String]) -> String {
        guard !strings.isEmpty else { return "" }

        let firstString = strings[0]
        var prefix = ""

        for (index, character) in firstString.enumerated() {
            for string in strings {
                if index >= string.count || string[string.index(string.startIndex, offsetBy: index)] != character {
                    return prefix
                }
            }
            prefix.append(character)
        }

        return prefix
    }
}
