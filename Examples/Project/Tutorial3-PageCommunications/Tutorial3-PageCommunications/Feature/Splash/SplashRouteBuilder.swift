import Foundation
import LinkNavigator

struct SplashRouteBuilder<RootNavigator: SingleLinkNavigator> {
  static func generate() -> RouteBuilderOf<RootNavigator> {
    let matchPath = AppLink.Path.splash.rawValue
    
    return .init(matchPath: matchPath) { navigator, item, dependency -> RouteViewController? in
      return WrappingController(matchPath: matchPath) {
        SplashPage(linkNavigator: navigator)
      }
    }
  }
}
