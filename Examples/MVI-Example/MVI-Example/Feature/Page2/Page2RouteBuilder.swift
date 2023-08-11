import LinkNavigator
import SwiftUI

struct Page2RouteBuilder: RouteBuilder {
  var matchPath: String { "page2" }

  var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
    { navigator, _, _ in
      WrappingController(matchPath: matchPath) {
        Page2View.build(
          intent: Page2Intent(initialState: .init(), navigator: navigator))
      }
    }
  }
}
