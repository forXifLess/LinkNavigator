import LinkNavigator
import SwiftUI

struct HomeRouteBuilder: RouteBuilder {
  var matchPath: String { "home" }

  var build: (LinkNavigatorType, [String : String], DependencyType) -> MatchingViewController? {
    { navigator, items, dep in
      WrappingController(matchingKey: matchPath) {
        HomeView(
          store: .init(
            initialState: Home.State(),
            reducer: Home()))
      }
    }
  }
}
