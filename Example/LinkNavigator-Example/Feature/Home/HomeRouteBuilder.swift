import LinkNavigator
import SwiftUI

struct HomeRouteBuilder: RouteBuilder {
  var matchPath: String { "home" }

  var build: (LinkNavigatorType, [String: String], DependencyType) -> UIViewController? {
    { navigator, items, dep in
      WrappingController(matchingKey: matchPath) {
        AnyView(HomeView.build(
          intent: HomeIntent(initialState: .init(), navigator: navigator)))
      }
    }
  }
}
