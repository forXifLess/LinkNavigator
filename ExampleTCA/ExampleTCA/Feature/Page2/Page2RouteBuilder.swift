import LinkNavigator
import SwiftUI

struct Page2RouteBuilder: RouteBuilder {
  var matchPath: String { "page2" }

  var build: (LinkNavigatorType, [String: String], DependencyType) -> UIViewController? {
    { navigator, items, dep in
      WrappingController(matchingKey: matchPath) {
        AnyView(Page2View(
          store: .init(
            initialState: Page2.State(),
            reducer: Page2())))
      }
    }
  }
}
