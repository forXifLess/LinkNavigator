import Foundation
import UIKit

public struct TabNavigationBuilder<Root, ItemValue: EmptyValueType> {

  // MARK: Lifecycle

  /// Initializes a new instance of `NavigationBuilder`.
  ///
  /// - Parameters:
  ///   - rootNavigator: The root navigator object.
  ///   - routeBuilderList: An array of route builders.
  ///   - dependency: The dependency required for constructing the routes.
  public init(
    rootNavigator: Root,
    routeBuilderList: [RouteBuilderOf<Root, ItemValue>],
    dependency: DependencyType)
  {
    self.rootNavigator = rootNavigator
    self.routeBuilderList = routeBuilderList
    self.dependency = dependency
  }

  // MARK: Internal

  /// The root navigator object.
  let rootNavigator: Root

  /// An array of `RouteBuilderOf` objects used to construct the routes.
  let routeBuilderList: [RouteBuilderOf<Root, ItemValue>]

  /// The dependency required for constructing the routes.
  let dependency: DependencyType

  public typealias MatchedViewController = MatchPathUsable & UIViewController
}

extension TabNavigationBuilder {
  public func build(item: LinkItem<ItemValue>) -> [RouteViewController] {
    item.pathList.compactMap { path in
      routeBuilderList.first(where: { $0.matchPath == path })?.routeBuild(rootNavigator, item.items, dependency)
    }
  }

  public func pickBuild(item: LinkItem<ItemValue>) -> RouteViewController? {
    routeBuilderList
      .first(where: { $0.matchPath == (item.pathList.first ?? "") })?
      .routeBuild(rootNavigator, item.items, dependency)
  }

  public func firstPick(controller: UINavigationController?, item: LinkItem<ItemValue>)
  -> RouteViewController? {
    guard let controller, let first = item.pathList.first else { return .none }
    return controller.viewControllers
      .compactMap { $0 as? RouteViewController }
      .first(where: { $0.matchPath == first })
  }

  public func lastPick(controller: UINavigationController?, item: LinkItem<ItemValue>) -> RouteViewController? {
    guard let controller, let first = item.pathList.first else { return .none }
    return controller.viewControllers
      .compactMap { $0 as? RouteViewController }
      .last(where: { $0.matchPath == first })
  }

  public func exceptFilter(
    controller: UINavigationController?,
    item: LinkItem<ItemValue>) -> [RouteViewController]
  {
    (controller?.viewControllers ?? [])
      .compactMap { $0 as? MatchedViewController }
      .filter { !item.pathList.contains($0.matchPath) }
  }

}
