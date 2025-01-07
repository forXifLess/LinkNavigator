import LinkNavigator
import SwiftUI

struct HomeRouteBuilder {

  @MainActor
  func generate() -> RouteBuilderOf<SingleLinkNavigator> {
    let matchPath = "home"
    return .init(matchPath: matchPath) { navigator, _, _ -> RouteViewController? in
      WrappingController(matchPath: matchPath) {
        HomeView(navigator: navigator)
      }
    }
  }
}
