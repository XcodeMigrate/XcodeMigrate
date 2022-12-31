//
// Rule.swift
// Copyright (c) 2022 Daohan Chong and other XcodeMigrate authors.
// MIT License.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the  Software), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED  AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

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
