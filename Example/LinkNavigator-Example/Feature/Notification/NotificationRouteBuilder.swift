import Foundation
import LinkNavigator

struct NotificationRouteBuilder: RouteBuildeableType {
  let matchPath: String
  var build: (EnviromentType, String, MatchURL, LinkNavigator) -> ViewableRouter {
    { enviroment, matchPath, matchURL, navigator in
      let intent = NotificationIntent(
        initialState: .init(),
        enviroment: enviroment,
        navigator: navigator)
      let view = NotificationView.build(intent: intent)
      let viewController = WrapperController(rootView: .init(view), key: matchPath)
      return .init(
        key: matchPath,
        viewController: viewController,
        matchURL: matchURL)
    }
  }
}
