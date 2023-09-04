import SwiftUI
import UIKit

// MARK: - Navigator

public class Navigator<ItemValue> {

  // MARK: Lifecycle

  public init(initialLinkItem: LinkItem<ItemValue>) {
    self.initialLinkItem = initialLinkItem
  }

  // MARK: Public

  public typealias MatchedViewController = MatchPathUsable & UIViewController

  // MARK: Internal

  let initialLinkItem: LinkItem<ItemValue>

}

// extension Navigator {
//  var viewControllers: [MatchedViewController] {
//    controller.viewControllers.compactMap { $0 as? MatchedViewController }
//  }
//
//  var currentPath: [String] {
//    controller.viewControllers.compactMap { $0 as? MatchedViewController }.map(\.matchPath)
//  }
// }

extension Navigator {

//  func launch<Root>(
//    rootNavigator: Root,
//    item: LinkItem<ItemValue>,
//    isAnimated: Bool,
//    routeBuilderList: [RouteBuilderOf<Root, ItemValue>],
//    dependency: DependencyType) -> [UIViewController]
//  {
//    let aa = item.pathList.compactMap { path in
//      routeBuilderList.first(where: { $0.matchPath == path })?.routeBuild(rootNavigator, item.items, dependency)
//    }
//  }
//
//  func replace<Root>(
//    rootNavigator: Root,
//    item: LinkItem<ItemValue>,
//    isAnimated: Bool,
//    routeBuilderList: [RouteBuilderOf<Root, ItemValue>],
//    dependency: DependencyType)
//  {
//    let newItemList = item.pathList.compactMap { path in
//      routeBuilderList.first(where: { $0.matchPath == path })?.routeBuild(rootNavigator, item.items, dependency)
//    }
//
//    controller.setViewControllers(newItemList, animated: isAnimated)
//  }
//
//  func replace2<Root>(
//    rootNavigator: Root,
//    item: LinkItem<ItemValue>,
//    isAnimated: Bool,
//    routeBuilderList: [RouteBuilderOf<Root, ItemValue>],
//    dependency: DependencyType) -> [UIViewController]
//  {
//    item.pathList.compactMap { path in
//      routeBuilderList.first(where: { $0.matchPath == path })?.routeBuild(rootNavigator, item.items, dependency)
//    }
//  }
//
//  func push<Root>(
//    rootNavigator: Root,
//    item: LinkItem<ItemValue>,
//    isAnimated: Bool,
//    routeBuilderList: [RouteBuilderOf<Root, ItemValue>],
//    dependency: DependencyType)
//  {
//    let newItemList = item.pathList.compactMap { path in
//      routeBuilderList.first(where: { $0.matchPath == path })?.routeBuild(rootNavigator, item.items, dependency)
//    }
//
//    controller.setViewControllers(controller.viewControllers + newItemList, animated: isAnimated)
//  }
//
//  func back(isAnimated: Bool) {
//    guard controller.viewControllers.count > 1 else { return }
//    controller.popViewController(animated: isAnimated)
//  }
//
//  func backOrNext<Root>(
//    rootNavigator: Root,
//    item: LinkItem<ItemValue>,
//    isAnimated: Bool,
//    routeBuilderList: [RouteBuilderOf<Root, ItemValue>],
//    dependency: DependencyType)
//  {
//    if let pick = find(path: item.pathList.first ?? "") {
//      controller.popToViewController(pick, animated: isAnimated)
//      return
//    }
//    push(
//      rootNavigator: rootNavigator,
//      item: item,
//      isAnimated: isAnimated,
//      routeBuilderList: routeBuilderList,
//      dependency: dependency)
//  }
//
//  func remove(item: LinkItem<ItemValue>) {
//    let new = viewControllers.filter { !item.pathList.contains($0.matchPath) }
//    guard new.count != viewControllers.count else { return }
//    controller.setViewControllers(new, animated: false)
//  }
//
//  func backToLast(item: LinkItem<ItemValue>, isAnimated: Bool) {
//    guard let path = item.pathList.first else { return }
//    guard let pick = viewControllers.last(where: { $0.matchPath == path }) else { return }
//    controller.popToViewController(pick, animated: isAnimated)
//  }
//
//  func find(path: String) -> MatchedViewController? {
//    controller.viewControllers
//      .compactMap { $0 as? MatchedViewController }
//      .first(where: { $0.matchPath == path })
//  }
//
//  func reset(isAnimated: Bool = false) {
//    controller.setViewControllers([], animated: isAnimated)
//  }
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
    dependency: DependencyType)
    -> RouteViewController?
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
      .compactMap { $0 as? MatchedViewController }
      .filter { !item.pathList.contains($0.matchPath) }
  }
}
