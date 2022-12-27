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
