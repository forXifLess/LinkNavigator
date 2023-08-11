import LinkNavigator
import SwiftUI

struct Page1RouteBuilder: RouteBuilder {
  var matchPath: String { "page1" }

  var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
    { navigator, _, _ in
      WrappingController(matchPath: matchPath) {
        Page1View.build(
          intent: Page1Intent(initialState: .init(), navigator: navigator))
      }
    }
  }
}
