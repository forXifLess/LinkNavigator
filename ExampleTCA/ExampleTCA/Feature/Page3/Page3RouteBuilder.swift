import LinkNavigator
import SwiftUI

struct Page3RouteBuilder: RouteBuilder {
  var matchPath: String { "page3" }

  var build: (LinkNavigatorType, [String: String], DependencyType) -> UIViewController? {
    { navigator, items, dep in
      WrappingController(matchingKey: matchPath) {
        AnyView(Page3View(
          store: .init(
            initialState: Page3.State(),
            reducer: Page3())))
      }
    }
  }
}
