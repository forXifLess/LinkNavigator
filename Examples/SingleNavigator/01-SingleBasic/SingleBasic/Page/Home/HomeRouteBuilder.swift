import LinkNavigator
import SwiftUI

struct HomeRouteBuilder {

  @MainActor
  func generate() -> RouteBuilderOf<SingleLinkNavigator> {
    let matchPath: String = "home"

    return .init(matchPath: matchPath) { navigator, _, _ -> RouteViewController? in
      WrappingController(matchPath: matchPath) {
        HomeView(navigator: navigator)
      }
    }
  }
}
