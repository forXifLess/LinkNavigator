import LinkNavigator
import Combine

class Page2LinkSubscriber: ObservableObject {
  private(set) var linkAction: PassthroughSubject<Page2LinkSubscriber.Action, Never> = .init()

  deinit {
    print("Page2LinkSubscriber deinit...")
  }
}

extension Page2LinkSubscriber: LinkNavigatorItemSubscriberProtocol {
  func receive(encodedItemString: String) {
    if let scope: Page3View.Page2InjectionData? = encodedItemString.decoded() {
      guard let scope else { return }
      linkAction.send(.page2ToData(scope))
    }
  }
}

extension Page2LinkSubscriber {
  enum Action {
    case page2ToData(Page3View.Page2InjectionData)
  }
}
