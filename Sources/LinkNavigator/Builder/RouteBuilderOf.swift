import UIKit

public typealias RouteViewController = MatchPathUsable & UIViewController

// MARK: - RouteBuilderOf

public struct RouteBuilderOf<RootNavigatorType> {

  let matchPath: String
  let routeBuild: (RootNavigatorType, String, DependencyType) -> RouteViewController?

  public init(
    matchPath: String,
    routeBuild: @escaping (RootNavigatorType, String, DependencyType) -> RouteViewController?)
  {
    self.matchPath = matchPath
    self.routeBuild = routeBuild
  }
}
