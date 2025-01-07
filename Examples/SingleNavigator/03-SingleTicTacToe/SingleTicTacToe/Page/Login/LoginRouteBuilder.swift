import LinkNavigator
import SwiftUI

struct LoginRouteBuilder {

  @MainActor
  func generate() -> RouteBuilderOf<SingleLinkNavigator> {
    let matchPath: String = "login"
    return .init(matchPath: matchPath) { navigator, _, _ -> RouteViewController? in
      WrappingController(matchPath: matchPath) {
        LoginView(navigator: navigator)
      }
    }
  }
}
