import Foundation
import LinkNavigator

struct PlaceListRouteBuilder: RouteBuildeableType {
  let matchPath: String

  var build: (EnviromentType, String, MatchURL, LinkNavigator) -> ViewableRouter {
    { enviroment, matchPath, matchURL, navigator in
      let intent = PlaceListIntent(
        initialState: .init(places: []),
        enviroment: enviroment,
        navigator: navigator)
      let view = PlaceListView.build(intent: intent)
      let viewController = WrapperController(rootView: .init(view), key: matchPath)
      return .init(
        key: matchPath,
        viewController: viewController,
        matchURL: matchURL)
    }
  }
}
