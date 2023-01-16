import LinkNavigator
import SwiftUI

struct Page2RouteBuilder: RouteBuilder {
  var matchPath: String { "page2" }

  var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
    { navigator, items, dep in
      WrappingController(matchPath: matchPath) {
        Page2View.build(
          intent: Page2Intent(initialState: .init(), navigator: navigator))
      }
    }
  }
}
