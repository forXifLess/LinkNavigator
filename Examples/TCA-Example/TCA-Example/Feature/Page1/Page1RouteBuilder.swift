import LinkNavigator
import SwiftUI

struct Page1RouteBuilder: RouteBuilder {
  var matchPath: String { "page1" }

  var build: (LinkNavigatorType, [String: String], DependencyType) -> UIViewController? {
    { navigator, items, dep in
      WrappingController(matchingKey: matchPath) {
        Page1View(
          store: .init(
            initialState: Page1.State(),
            reducer: Page1()))
      }
    }
  }
}
