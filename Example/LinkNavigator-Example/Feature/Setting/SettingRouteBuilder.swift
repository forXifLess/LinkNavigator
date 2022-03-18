import Foundation
import LinkNavigator

struct SettingRouteBuilder: RouteBuildeableType {
  let matchPath: String
  var build: (EnviromentType, String, MatchURL, LinkNavigator) -> ViewableRouter {
    { enviroment, matchPath, matchURL, navigator in
      let intent = SettingIntent(
        initialState: .init(),
        enviroment: enviroment,
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
