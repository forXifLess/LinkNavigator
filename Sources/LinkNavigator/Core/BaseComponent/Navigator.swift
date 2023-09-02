import SwiftUI
import UIKit

// MARK: - Navigator

public class Navigator<ItemValue> {

  public typealias MatchedViewController = MatchPathUsable & UIViewController

  let initialLinkItem: LinkItem<ItemValue>

  public init(initialLinkItem: LinkItem<ItemValue>) {
    self.initialLinkItem = initialLinkItem
  }
}

extension Navigator {
  func build<Root>(
    rootNavigator: Root,
    item: LinkItem<ItemValue>,
    routeBuilderList: [RouteBuilderOf<Root, ItemValue>],
    dependency: DependencyType) -> [RouteViewController]
  {
    item.pathList.compactMap { path in
      routeBuilderList.first(where: { $0.matchPath == path })?.routeBuild(rootNavigator, item.items, dependency)
    }
  }

  func pickBuild<Root>(
    rootNavigator: Root,
    item: LinkItem<ItemValue>,
    routeBuilderList: [RouteBuilderOf<Root, ItemValue>],
    dependency: DependencyType) -> RouteViewController?
  {
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
      .compactMap{ $0 as? MatchedViewController }
      .filter{ !item.pathList.contains($0.matchPath) }

  }
}
