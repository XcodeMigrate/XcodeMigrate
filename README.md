# XcodeMigrate

Generate Bazel BUILD files from Xcode projects.

Long term plans:

- Generate [Buck2](https://github.com/facebookincubator/buck2) files
- Generate [Xcodegen](https://github.com/yonaskolb/XcodeGen) YAML files

This project is still in its early stages. It is not yet ready for production use.
If you have any questions or ideas, please feel free to [open a discussion](https://github.com/XcodeMigrate/XcodeMigrate/discussions/new).

## Why XcodeMigrate?

Over nearly ten years of my personal experience of Apple development, I strongly believe that developers should be able to keep focused on creative things rather than wasting time on compile time.

Bazel is designed for this purpose.

However, migrating existing (large) Xcode project to Bazel is not easy. It requires a lot of manual work.
`BazelMigrate` is created to help developers to migrate existing Xcode projects to Bazel with minimal manual work.

## Goals

- Easy and quick setup process for most projects
- Full support [rules_xcodeproj](https://github.com/buildbuddy-io/rules_xcodeproj)
- Mixed language target (Objective-C/Swift) generation using [rules_ios](https://github.com/bazel-ios/rules_ios)

## Design

- End-to-end testing with Xcode projects generated by Tuist
- Decoupling Xcode project parser and generator

```
XcodeMigrate
 ├─XcodeParser - Parsing layer
 │  └─XcodeProj
 ├─XcodeAbstraction - Modeling layer (without any dependency to XcodeProj)
 └─FoundationExtension
 ```

## License

XcodeMigrate is released under the MIT license. See LICENSE for details.
