import Combine
import LinkNavigator

// MARK: - Page2LinkSubscriber

class Page2LinkSubscriber: ObservableObject {

  // MARK: Lifecycle

  deinit {
    LogManager.default.debug("Page2LinkSubscriber deinit...")
  }

  // MARK: Internal

  @Published var linkAction: Page3View.Page2InjectionData? = .none

}

// MARK: LinkNavigatorItemSubscriberProtocol

extension Page2LinkSubscriber: LinkNavigatorItemSubscriberProtocol {
  func receive(encodedItemString: String) {
    if let scope: Page3View.Page2InjectionData? = encodedItemString.decoded() {
      linkAction = scope
    }
  }
}
