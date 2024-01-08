import Foundation
import UIKit

// MARK: - TabNavigationBuilder

public struct TabNavigationBuilder<Root> {

  // MARK: Lifecycle

  /// Initializes a new instance of `NavigationBuilder`.
  ///
  /// - Parameters:
  ///   - rootNavigator: The root navigator object.
  ///   - routeBuilderList: An array of route builders.
  ///   - dependency: The dependency required for constructing the routes.
  public init(
    rootNavigator: Root,
    routeBuilderList: [RouteBuilderOf<Root>],
    dependency: DependencyType)
  {
    self.rootNavigator = rootNavigator
    self.routeBuilderList = routeBuilderList
    self.dependency = dependency
  }

  // MARK: Public

  public typealias MatchedViewController = MatchPathUsable & UIViewController

  // MARK: Internal

  /// The root navigator object.
  let rootNavigator: Root

  /// An array of `RouteBuilderOf` objects used to construct the routes.
  let routeBuilderList: [RouteBuilderOf<Root>]

  /// The dependency required for constructing the routes.
  let dependency: DependencyType

}

extension TabNavigationBuilder {
  public func build(item: LinkItem) -> [RouteViewController] {
    item.pathList.compactMap { path in
      routeBuilderList.first(where: { $0.matchPath == path })?.routeBuild(rootNavigator, item.encodedItemString, dependency)
    }
  }

  public func pickBuild(item: LinkItem) -> RouteViewController? {
    routeBuilderList
      .first(where: { $0.matchPath == (item.pathList.first ?? "") })?
      .routeBuild(rootNavigator, item.encodedItemString, dependency)
  }

  public func firstPick(controller: UINavigationController?, item: LinkItem)
    -> RouteViewController?
  {
    guard let controller, let first = item.pathList.first else { return .none }
    return controller.viewControllers
      .compactMap { $0 as? RouteViewController }
      .first(where: { $0.matchPath == first })
  }

  public func lastPick(controller: UINavigationController?, item: LinkItem) -> RouteViewController? {
    guard let controller, let last = item.pathList.last else { return .none }
    return controller.viewControllers
      .compactMap { $0 as? RouteViewController }
      .last(where: { $0.matchPath == last })
  }

  public func exceptFilter(
    controller: UINavigationController?,
    item: LinkItem) -> [RouteViewController]
  {
    (controller?.viewControllers ?? [])
      .compactMap { $0 as? MatchedViewController }
      .filter { !item.pathList.contains($0.matchPath) }
  }

  public func isContainSequence(item: LinkItem) -> Bool {
    let currentPathJoin = routeBuilderList.map { $0.matchPath }.joined(separator: ",")
    let itemPathJoin = item.pathList.joined(separator: ",")

    return currentPathJoin.contains(itemPathJoin)
  }
}
