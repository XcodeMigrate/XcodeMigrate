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

    func removePrefix(prefix: String) -> String {
        if hasPrefix(prefix) {
            let index = index(startIndex, offsetBy: prefix.count)
            return String(self[index...])
        } else {
            return self
        }
    }
}

public extension Array where Element == String {
    func toArrayLiteralString() -> String {
        guard !isEmpty else {
            return "[]"
        }
        return "[\n" + map { "\"\($0)\"" }.joined(separator: ",\n") + "\n]"
    }
}
