
/// TODO: Find a better naming of this type
///
/// I was thinking about BazelModule. But we already have <https://bazel.build/build/bzlmod#modules>.
struct GeneratedBazelTarget {
    let rules: [BazelRule]
    let content: String

    init(rules: [BazelRule], content: String) {
        self.rules = rules
        self.content = content
    }
}
