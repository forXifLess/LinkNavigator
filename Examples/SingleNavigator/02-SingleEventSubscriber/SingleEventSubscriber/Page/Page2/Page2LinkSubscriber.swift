import LinkNavigator
import Combine

class Page2LinkSubscriber: ObservableObject {
  @Published var linkAction: Page3View.Page2InjectionData? = .none

  deinit {
    print("Page2LinkSubscriber deinit...")
  }
}

extension Page2LinkSubscriber: LinkNavigatorItemSubscriberProtocol {
  func receive(encodedItemString: String) {
    if let scope: Page3View.Page2InjectionData? = encodedItemString.decoded() {
      linkAction = scope
    }
  }
}
