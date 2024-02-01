import Foundation
import Logging

// MARK: - LogManager

struct LogManager {
  private let log = Logger(label: "io.forxifless.linknavigator.TabEventSubscriber")

  static let `default` = LogManager()
}

extension LogManager {
  func debug(_ message: Logger.Message) {
    log.info(message)
  }
}
