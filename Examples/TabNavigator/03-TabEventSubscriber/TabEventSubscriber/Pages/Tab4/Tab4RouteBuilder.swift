import LinkNavigator
import SwiftUI

struct Tab4RouteBuilder {

  @MainActor
  func generate() -> RouteBuilderOf<TabPartialNavigator> {
    let matchPath: String = "tab4"
    return .init(matchPath: matchPath) { navigator, _, _ -> RouteViewController? in
      let eventSubscriber = EventSubscriber()

      return WrappingController(matchPath: matchPath, eventSubscriber: eventSubscriber) {
        Tab4Page(navigator: navigator, eventSubscriber: eventSubscriber)
      }
    }
  }
}
