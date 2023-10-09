import Foundation
import LinkNavigator

struct SettingRouteBuilder<RootNavigator: SingleLinkNavigator> {
  static func generate() -> RouteBuilderOf<RootNavigator> {
    let matchPath = AppLink.Path.setting.rawValue

    return .init(matchPath: matchPath) { navigator, item, dependency -> RouteViewController? in
      return WrappingController(matchPath: matchPath) {
        SettingPage(linkNavigator: navigator)
      }
    }
  }
}
