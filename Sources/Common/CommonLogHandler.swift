//
// CommonLogHandler.swift
// Copyright (c) 2022 Daohan Chong and other XcodeMigrate authors.
// MIT License.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the  Software), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED  AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import Logging

public struct CommonLogHandler: LogHandler {
    public var metadata: Logging.Logger.Metadata = [:]
    public var logLevel: Logging.Logger.Level = .info
    public subscript(metadataKey key: String) -> Logging.Logger.Metadata.Value? {
        get { metadata[key] }
        set { metadata[key] = newValue }
    }

    private let label: String

    public init(label: String) {
        self.label = label
    }

    public func log(level: Logging.Logger.Level, message: Logging.Logger.Message, metadata _: Logging.Logger.Metadata?, file _: String, function _: String, line _: UInt) {
        let color: String = {
            switch level {
            case .trace:
                return Constants.black
            case .debug:
                return Constants.blue
            case .info:
                return Constants.default
            case .notice:
                return Constants.cyan
            case .warning:
                return Constants.yellow
            case .error:
                return Constants.red
            case .critical:
                return Constants.magenta
            }
        }()

        #if DEBUG
            if level == .debug || level == .trace {
                return
            }
        #endif

        print("\(color)[\(label)] \(level): \(message)\(Constants.reset)")
    }
}

private extension CommonLogHandler {
    enum Constants {
        static let black = "\u{001B}[0;30m"
        static let red = "\u{001B}[0;31m"
        static let green = "\u{001B}[0;32m"
        static let yellow = "\u{001B}[0;33m"
        static let blue = "\u{001B}[0;34m"
        static let magenta = "\u{001B}[0;35m"
        static let cyan = "\u{001B}[0;36m"
        static let white = "\u{001B}[0;37m"

        static let reset = "\u{001B}[0m"

        static let `default` = "\u{001B}[0;0m"
    }
}
