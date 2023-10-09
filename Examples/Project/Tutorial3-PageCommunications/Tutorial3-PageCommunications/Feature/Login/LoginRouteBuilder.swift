import Foundation
import LinkNavigator

struct LoginRouteBuilder<RootNavigator: SingleLinkNavigator> {
  static func generate() -> RouteBuilderOf<RootNavigator> {
    let matchPath = AppLink.Path.login.rawValue

    return .init(matchPath: matchPath) { navigator, item, dependency -> RouteViewController? in
      return WrappingController(matchPath: matchPath) {
        LoginPage(linkNavigator: navigator)
      }
    }
  }
}
