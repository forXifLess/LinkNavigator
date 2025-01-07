import LinkNavigator
import SwiftUI

struct Tab1RouteBuilder {

  @MainActor
  func generate() -> RouteBuilderOf<TabPartialNavigator> {
    let matchPath = "tab1"
    return .init(matchPath: matchPath) { navigator, _, _ -> RouteViewController? in
      let eventSubscriber = EventSubscriber()

      return WrappingController(matchPath: matchPath, eventSubscriber: eventSubscriber) {
        Tab1Page(navigator: navigator, eventSubscriber: eventSubscriber)
      }
    }
  }
}
