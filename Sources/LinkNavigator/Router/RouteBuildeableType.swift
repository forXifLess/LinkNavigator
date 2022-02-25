import Foundation

public protocol RouteBuildeableType {
  var matchPath: String { get }
  var build: (EnviromentType, String, MatchURL, LinkNavigator) -> ViewableRouter { get }
}
