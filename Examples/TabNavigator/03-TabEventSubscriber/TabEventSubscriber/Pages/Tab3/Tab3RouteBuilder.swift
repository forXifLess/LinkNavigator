import LinkNavigator
import SwiftUI

struct Tab3RouteBuilder {

  @MainActor
  func generate() -> RouteBuilderOf<TabPartialNavigator> {
    let matchPath = "tab3"
    return .init(matchPath: matchPath) { navigator, _, _ -> RouteViewController? in
      let eventSubscriber = EventSubscriber()

      return WrappingController(matchPath: matchPath, eventSubscriber: eventSubscriber) {
        Tab3Page(navigator: navigator, eventSubscriber: eventSubscriber)
      }
    }
  }
}
