import LinkNavigator
import SwiftUI

struct HomeRouteBuilder<RootNavigator: RootNavigatorType> {

  static func generate() -> RouteBuilderOf<RootNavigator> {
    var matchPath: String { "home" }
    return .init(matchPath: matchPath) { navigator, _, _ -> RouteViewController? in
      WrappingController(matchPath: matchPath) {
        HomeView(navigator: navigator)
      }
    }
  }
}
