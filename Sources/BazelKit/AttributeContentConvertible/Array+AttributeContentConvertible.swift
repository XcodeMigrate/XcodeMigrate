import Foundation

extension Array: AttributeContentConvertible where Element: AttributeContentConvertible {
    public func toAttributeContent() -> String {
        return "[" + map { $0.toAttributeContent() }.joined(separator: ",") + "]"
    }
}
