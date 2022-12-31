extension String {
    func doubleQuoted() -> String {
        "\"\(self)\""
    }
}

extension String: AttributeContentConvertible {
    public func toAttributeContent() -> String {
        doubleQuoted()
    }
}
