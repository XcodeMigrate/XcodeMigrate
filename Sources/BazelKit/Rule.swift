import Foundation

public struct Rule {
  let name: String
  var attributes: [String: AttributeContentConvertible]

  public init(name: String) {
    self.name = name
    attributes = [:]
  }
}

public extension Rule {
  mutating func attr(key: String, value: AttributeContentConvertible) -> Self {
    attributes[key] = value
    return self
  }

  var stringRepresentation: String {
    var str = "\(name)("
    var attrs = [String]()
    for (key, value) in attributes {
      attrs.append("\(key)=\(value.toAttributeContent())")
    }
    str += attrs.joined(separator: ", ")
    str += ")"
    return str
  }
}
