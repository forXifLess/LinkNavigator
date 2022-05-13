import Foundation
import LinkNavigator

struct NotificationRouteBuilder: RouteBuildeableType {
  let matchPath: String
  var build: (EnvironmentType, String, MatchURL, LinkNavigator) -> ViewableRouter {
    { environment, matchPath, matchURL, navigator in
      let intent = NotificationIntent(
        initialState: .init(),
        environment: environment,
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
