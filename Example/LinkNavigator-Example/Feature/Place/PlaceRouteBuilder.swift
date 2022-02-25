import Foundation
import LinkNavigator

struct PlaceRouteBuilder: RouteBuildeableType {
  let matchPath: String

  var build: (EnviromentType, String, MatchURL, LinkNavigator) -> ViewableRouter {
    { enviroment, matchPath, matchURL, navigator in
      var placeID: Int {
        let strID = matchURL.query.first(where: { $0.key == "place_id" })?.value ?? "0"
        return Int(strID) ?? .zero
      }

      let intent = PlaceIntent(
        initialState: .init(placeID: placeID),
        enviroment: enviroment,
        navigator: navigator)
      let view = PlaceView.build(intent: intent)
      let viewController = WrapperController(rootView: .init(view), key: matchPath)
      return .init(
        key: matchPath,
        viewController: viewController,
        matchURL: matchURL)
    }
  }
}
