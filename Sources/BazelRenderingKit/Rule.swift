import Collections
import Foundation

public struct Rule {
    let name: String
    var attributes: OrderedDictionary<String, AttributeContentConvertible>

    public init(name: String) {
        self.name = name
        attributes = [:]
    }
}

public extension Rule {
    func attr(key: String, value: AttributeContentConvertible) -> Self {
        var mutableSelf = self
        mutableSelf.attributes[key] = value
        return mutableSelf
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
