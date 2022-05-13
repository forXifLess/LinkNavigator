import Foundation
import LinkNavigator

struct PlaceRouteBuilder: RouteBuildeableType {
  let matchPath: String

  var build: (EnvironmentType, String, MatchURL, LinkNavigator) -> ViewableRouter {
    { environment, matchPath, matchURL, navigator in
      var model: PlaceViewModel.DomainInfo {
        let model: PlaceViewModel.DomainInfo? = matchURL.query.first(where: { $0.key == "placeInfo"})?.value.decoded()
        return model ?? .init(imageURL: "", size: .zero, name: "", address: "", detailAddress: "", coordinateUnit: .init(longtitude: 0, latitude: 0), link: .none, qrImageURL: .none, status: .none, isLinkAccessable: false)
      }
      let intent = PlaceIntent(
        initialState: .init(placeID: 0),
        environment: environment,
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
