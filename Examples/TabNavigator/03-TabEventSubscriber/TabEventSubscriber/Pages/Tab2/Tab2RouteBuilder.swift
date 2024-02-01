import LinkNavigator
import SwiftUI

struct Tab2RouteBuilder<RootNavigator: RootNavigatorType> {
  static func generate() -> RouteBuilderOf<RootNavigator> {
    var matchPath: String { "tab2" }
    return .init(matchPath: matchPath) { navigator, _, _ -> RouteViewController? in
      let eventSubscriber = EventSubscriber()

      return WrappingController(matchPath: matchPath, eventSubscriber: eventSubscriber) {
        Tab2Page(navigator: navigator, eventSubscriber: eventSubscriber)
      }
    }
  }
}
