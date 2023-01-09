import LinkNavigator
import SwiftUI

struct Page1RouteBuilder: RouteBuilder {
  var matchPath: String { "page1" }

  var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
    { navigator, items, dep in
      WrappingController(matchingKey: matchPath) {
        Page1View.build(
          intent: Page1Intent(initialState: .init(), navigator: navigator))
      }
    }
  }
}
