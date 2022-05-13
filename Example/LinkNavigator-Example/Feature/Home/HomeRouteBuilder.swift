import Foundation
import LinkNavigator

struct HomeRouteBuilder: RouteBuildeableType {
  let matchPath: String
  var build: (EnvironmentType, String, MatchURL, LinkNavigator) -> ViewableRouter {
    { enviroment, matchPath, matchURL, navigator in
      let intent = HomeIntent(
        initialState: .init(),
        environment: enviroment,
        navigator: navigator)

      let view = HomeView.build(intent: intent)
      let viewController = WrapperController(rootView: .init(view), key: matchPath, callbackCompletion: { dic in
        guard let item = dic.first(where: { $0.key == "homeKey"})?.value.value else { return }
        intent.receiveCallback(item: item)

      })

      return .init(
        key: matchPath,
        viewController: viewController,
        matchURL: matchURL)
    }
  }
}
