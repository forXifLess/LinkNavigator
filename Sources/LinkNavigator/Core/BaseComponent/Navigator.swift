import SwiftUI
import UIKit

// MARK: - NavigationBuilder

public class NavigationBuilder<Root, ItemValue: EmptyValueType> {

  // MARK: Lifecycle

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

  let rootNavigator: Root
  let routeBuilderList: [RouteBuilderOf<Root, ItemValue>]
  let dependency: DependencyType

}

extension NavigationBuilder {
  func build(item: LinkItem<ItemValue>) -> [RouteViewController] {
    item.pathList.compactMap { path in
      routeBuilderList.first(where: { $0.matchPath == path })?.routeBuild(rootNavigator, item.items, dependency)
    }
  }

  func pickBuild(item: LinkItem<ItemValue>) -> RouteViewController? {
    routeBuilderList
      .first(where: { $0.matchPath == (item.pathList.first ?? "") })?
      .routeBuild(rootNavigator, item.items, dependency)
  }

  func firstPick(controller: UINavigationController?, item: LinkItem<ItemValue>) -> RouteViewController? {
    guard let controller, let first = item.pathList.first else { return .none }
    return controller.viewControllers
      .compactMap { $0 as? RouteViewController }
      .first(where: { $0.matchPath == first })
  }

  func lastPick(controller: UINavigationController?, item: LinkItem<ItemValue>) -> RouteViewController? {
    guard let controller, let first = item.pathList.first else { return .none }
    return controller.viewControllers
      .compactMap { $0 as? RouteViewController }
      .last(where: { $0.matchPath == first })
  }

  func exceptFilter(controller: UINavigationController?, item: LinkItem<ItemValue>) -> [RouteViewController] {
    (controller?.viewControllers ?? [])
      .compactMap { $0 as? RouteViewController }
      .filter { !item.pathList.contains($0.matchPath) }
  }
}
