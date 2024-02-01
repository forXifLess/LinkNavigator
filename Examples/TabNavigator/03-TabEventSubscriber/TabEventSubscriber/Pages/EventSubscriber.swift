import Combine
import LinkNavigator

// MARK: - EventSubscriber

class EventSubscriber {

  // MARK: Lifecycle

  deinit {
    LogManager.default.debug("EventSubscriber deinit...")
  }

  // MARK: Internal

  let action: PassthroughSubject<EventParam, Never> = .init()

}

// MARK: LinkNavigatorItemSubscriberProtocol

extension EventSubscriber: LinkNavigatorItemSubscriberProtocol {
  func receive(encodedItemString: String) {
    if let scope: EventParam = encodedItemString.decoded() {
      action.send(scope)
    }
  }
}

// MARK: - EventParam

public struct EventParam: Codable {
  public let action: Action

  public init(action: Action) {
    self.action = action
  }
}

// MARK: EventParam.Action

extension EventParam {
  public enum Action: Codable {
    case sendMessage(String)
  }
}
