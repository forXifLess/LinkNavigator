import UIKit

public typealias RouteViewController = MatchPathUsable & UIViewController

public struct RouteBuilderOf<MainNavigatorType> {

  let matchPath: String
  let routeBuild: (MainNavigatorType, [String: String], DependencyType) -> RouteViewController?

  public init(
    matchPath: String,
    routeBuild: @escaping (MainNavigatorType, [String : String], DependencyType) -> RouteViewController?)
  {
    self.matchPath = matchPath
    self.routeBuild = routeBuild
  }
}
