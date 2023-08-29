import UIKit

public typealias RouteViewController = MatchPathUsable & UIViewController

// MARK: - RouteBuilderOf

public struct RouteBuilderOf<RootNavigatorType, ItemValueType> {

  let matchPath: String
  let routeBuild: (RootNavigatorType, ItemValueType, DependencyType) -> RouteViewController?

  public init(
    matchPath: String,
    routeBuild: @escaping (RootNavigatorType, ItemValueType, DependencyType) -> RouteViewController?)
  {
    self.matchPath = matchPath
    self.routeBuild = routeBuild
  }
}
