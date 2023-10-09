import SwiftUI
import UIKit

// MARK: - NavigationBuilder

/// A class that facilitates the construction of a navigation structure.
///
/// Generics:
/// - Root: The type representing the root navigator.
/// - ItemValue: A type that conforms to `EmptyValueType` representing the item values.
public class SingleNavigationBuilder<Root, ItemValue: EmptyValueType> {

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
}

extension SingleNavigationBuilder {
  
  /// Builds a list of `RouteViewController` based on the provided `LinkItem`.
  ///
  /// - Parameter item: A `LinkItem` containing the paths and associated values.
  /// - Returns: An array of `RouteViewController` constructed based on the `LinkItem`.
  func build(item: LinkItem<ItemValue>) -> [RouteViewController] {
    item.pathList.compactMap { path in
      routeBuilderList.first(where: { $0.matchPath == path })?.routeBuild(rootNavigator, item.items, dependency)
    }
  }

  /// Selects and builds a `RouteViewController` based on the first match in the `LinkItem`.
  ///
  /// - Parameter item: A `LinkItem` containing the paths and associated values.
  /// - Returns: A `RouteViewController` instance based on the first matching path in the `LinkItem` or nil if no match is found.
  func pickBuild(item: LinkItem<ItemValue>) -> RouteViewController? {
    routeBuilderList
      .first(where: { $0.matchPath == (item.pathList.first ?? "") })?
      .routeBuild(rootNavigator, item.items, dependency)
  }

  /// Selects the first `RouteViewController` in the navigation stack that matches the first path in the `LinkItem`.
  ///
  /// - Parameters:
  ///   - controller: An optional `UINavigationController`.
  ///   - item: A `LinkItem` containing the paths and associated values.
  /// - Returns: A `RouteViewController` instance that matches the first path in the `LinkItem` or nil if no match is found.
  func firstPick(controller: UINavigationController?, item: LinkItem<ItemValue>) -> RouteViewController? {
    guard let controller, let first = item.pathList.first else { return .none }
    return controller.viewControllers
      .compactMap { $0 as? RouteViewController }
      .first(where: { $0.matchPath == first })
  }

  /// Selects the last `RouteViewController` in the navigation stack that matches the first path in the `LinkItem`.
  ///
  /// - Parameters:
  ///   - controller: An optional `UINavigationController`.
  ///   - item: A `LinkItem` containing the paths and associated values.
  /// - Returns: A `RouteViewController` instance that matches the first path in the `LinkItem` or nil if no match is found.
  func lastPick(controller: UINavigationController?, item: LinkItem<ItemValue>) -> RouteViewController? {
    guard let controller, let first = item.pathList.first else { return .none }
    return controller.viewControllers
      .compactMap { $0 as? RouteViewController }
      .last(where: { $0.matchPath == first })
  }

  /// Filters out `RouteViewController` instances that match the paths in the `LinkItem` from the navigation stack.
  ///
  /// - Parameters:
  ///   - controller: An optional `UINavigationController`.
  ///   - item: A `LinkItem` containing the paths and associated values.
  /// - Returns: An array of `RouteViewController` instances that do not match any path in the `LinkItem`.
  func exceptFilter(controller: UINavigationController?, item: LinkItem<ItemValue>) -> [RouteViewController] {
    (controller?.viewControllers ?? [])
      .compactMap { $0 as? RouteViewController }
      .filter { !item.pathList.contains($0.matchPath) }
  }
}
