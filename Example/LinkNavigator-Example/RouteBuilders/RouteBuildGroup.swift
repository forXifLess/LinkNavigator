import LinkNavigator
import UIKit

// MARK: - RouteBuildGroup

struct RouteBuildGroup {

}

// MARK: RouterBuildGroupType

extension RouteBuildGroup: RouterBuildGroupType {
  var builders: [RouteBuildeableType] {
    [
      HomeRouteBuilder(matchPath: "home"),
      SettingRouteBuilder(matchPath: "setting"),
      NotificationRouteBuilder(matchPath: "notification"),
      PlaceRouteBuilder(matchPath: "place"),
      PlaceListRouteBuilder(matchPath: "placeList"),
    ]
  }
}
