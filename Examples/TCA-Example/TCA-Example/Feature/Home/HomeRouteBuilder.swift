import LinkNavigator
import SwiftUI

struct HomeRouteBuilder: RouteBuilder {
  var matchPath: String { "home" }

  var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
    { _, _, _ in
      WrappingController(matchPath: matchPath) {
        HomeView(
          store: .init(
            initialState: Home.State(),
            reducer: {
              Home()
            }))
      }
    }
  }
}
