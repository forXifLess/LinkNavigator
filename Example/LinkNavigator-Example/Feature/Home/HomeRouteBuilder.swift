import Foundation
import LinkNavigator

struct HomeRouteBuilder: RouteBuildeableType {
  let matchPath: String
  var build: (EnviromentType, String, MatchURL, LinkNavigator) -> ViewableRouter {
    { enviroment, matchPath, matchURL, navigator in
      let intent = HomeIntent(
        initialState: .init(),
        enviroment: enviroment,
        navigator: navigator)
      let view = HomeView.build(intent: intent)
      let viewController = WrapperController(rootView: .init(view), key: matchPath)
      return .init(
        key: matchPath,
        viewController: viewController,
        matchURL: matchURL)
    }
  }
}