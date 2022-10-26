import LinkNavigator
import SwiftUI

struct Page4RouteBuilder: RouteBuilder {
  var matchPath: String { "page4" }

  var build: (LinkNavigatorType, [String: String], DependencyType) -> UIViewController? {
    { navigator, items, dep in
      WrappingController(matchingKey: matchPath) {
        AnyView(Page4View(
          store: .init(
            initialState: Page4.State(),
            reducer: Page4())))
      }
    }
  }
}
