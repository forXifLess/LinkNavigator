import LinkNavigator
import SwiftUI

struct Tab3RouteBuilder<RootNavigator: RootNavigatorType> {

  static func generate() -> RouteBuilderOf<RootNavigator> {
    var matchPath: String { "tab3" }
    return .init(matchPath: matchPath) { navigator, items, diContainer -> RouteViewController? in
      let eventSubscriber = EventSubscriber()

      return WrappingController(matchPath: matchPath, eventSubscriber: eventSubscriber) {
        Tab3Page(navigator: navigator, eventSubscriber: eventSubscriber)
      }
    }
  }
}
