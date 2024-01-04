import LinkNavigator
import SwiftUI

struct Page2RouteBuilder<RootNavigator: RootNavigatorType> {

  static func generate() -> RouteBuilderOf<RootNavigator> {
    var matchPath: String { "page2" }
    return .init(matchPath: matchPath) { navigator, items, diContainer -> RouteViewController? in
      let linkSubscriber = Page2LinkSubscriber()
      return WrappingController(
        matchPath: matchPath,
        eventSubscriber: linkSubscriber)
      {
        Page2View(
          navigator: navigator,
          linkSubscriber: linkSubscriber)
      }
    }
  }
}
