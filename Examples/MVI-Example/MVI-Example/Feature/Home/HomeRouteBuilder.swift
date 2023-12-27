import LinkNavigator
import SwiftUI

struct HomeRouteBuilder: RouteBuilder {
  var matchPath: String { "home" }

  var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
    { navigator, _, _ in
      WrappingController(matchPath: matchPath) {
        HomeView.build(
          intent: HomeIntent(initialState: .init(), navigator: navigator))
      }
    }
  }
}