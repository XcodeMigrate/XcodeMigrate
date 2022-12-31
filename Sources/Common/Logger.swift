//
// Logger.swift
// Copyright (c) 2022 Daohan Chong
// MIT License.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the  Software), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED  AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import struct Logging.Logger
import enum Logging.LoggingSystem

public struct Logger {
    public let label: String
    private let logger: Logging.Logger
    public init(label: String) {
        self.label = label
        self.logger = Logging.Logger(label: label) { label in
            CommonLogHandler(label: label)
        }
    }
}

public extension Logger {
    func debug(_ message: Logging.Logger.Message) {
        logger.debug(message)
    }

    func info(_ message: Logging.Logger.Message) {
        logger.info(message)
    }

    func notice(_ message: Logging.Logger.Message) {
        logger.notice(message)
    }

    func warning(_ message: Logging.Logger.Message) {
        logger.warning(message)
    }

    func error(_ message: Logging.Logger.Message) {
        logger.error(message)
    }

    func critical(_ message: Logging.Logger.Message) {
        logger.critical(message)
    }
}
