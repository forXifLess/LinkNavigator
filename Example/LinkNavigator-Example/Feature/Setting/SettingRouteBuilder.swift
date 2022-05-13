import Foundation
import LinkNavigator

struct SettingRouteBuilder: RouteBuildeableType {
  let matchPath: String
  var build: (EnvironmentType, String, MatchURL, LinkNavigator) -> ViewableRouter {
    { enviroment, matchPath, matchURL, navigator in
      let intent = SettingIntent(
        initialState: .init(),
        environment: enviroment,
        navigator: navigator)
      let view = SettingView.build(intent: intent)
      let viewController = WrapperController(rootView: .init(view), key: matchPath) {
        print("AAA")
      }
      return .init(
        key: matchPath,
        viewController: viewController,
        matchURL: matchURL)
    }
  }
}
