import LinkNavigator
import Combine

class EventSubscriber {
  let action: PassthroughSubject<EventParam, Never> = .init()

  deinit {
    print("Page2LinkSubscriber deinit...")
  }
}

extension EventSubscriber: LinkNavigatorItemSubscriberProtocol {
  func receive(encodedItemString: String) {
    if let scope: EventParam = encodedItemString.decoded() {
      self.action.send(scope)
    }
  }
}

public struct EventParam: Codable {
  public let action: Action

  public init(action: Action) {
    self.action = action
  }
}

extension EventParam {
  public enum Action: Codable {
    case sendMessage(String)
  }
}
