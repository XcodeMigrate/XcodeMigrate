import Foundation

public extension Collection where Element: AttributeContentConvertible {
  func toAttributeContent() -> String {
    return "[" + map { "\"\($0.toAttributeContent())\"" }.joined(separator: ",") + "]"
  }
}
