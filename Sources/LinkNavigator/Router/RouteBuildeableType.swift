import Foundation

public protocol RouteBuildeableType {
  var matchPath: String { get }
  var build: (EnvironmentType, String, MatchURL, LinkNavigator) -> ViewableRouter { get }
}
