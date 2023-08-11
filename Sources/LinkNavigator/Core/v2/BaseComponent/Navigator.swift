import SwiftUI
import UIKit

// MARK: - Navigator

public struct Navigator {

  public typealias MatchedViewController = UIViewController & MatchPathUsable

  let initialLinkItem: LinkItem
  let controller: UINavigationController

  public init(
    initialLinkItem: LinkItem,
    controller: UINavigationController = .init())
  {
    self.initialLinkItem = initialLinkItem
    self.controller = controller
  }
}

extension Navigator {
  var viewControllers: [MatchedViewController] {
    controller.viewControllers.compactMap { $0 as? MatchedViewController }
  }

  var currentPath: [String] {
    controller.viewControllers.compactMap{ $0 as? MatchedViewController }.map(\.matchPath)
  }
}

extension Navigator {
  func replace<Root>(
    rootNavigator: Root,
    item: LinkItem,
    isAnimated: Bool,
    routeBuilderList: [RouteBuilderOf<Root>],
    dependency: DependencyType)
  {
    let newItemList = item.paths.compactMap { path in
      routeBuilderList.first(where: { $0.matchPath == path })?.routeBuild(rootNavigator, item.items, dependency)
    }

    controller.setViewControllers(newItemList, animated: isAnimated)
  }

  func push<Root>(
    rootNavigator: Root,
    item: LinkItem,
    isAnimated: Bool,
    routeBuilderList: [RouteBuilderOf<Root>],
    dependency: DependencyType)
  {
    let newItemList = item.paths.compactMap { path in
      routeBuilderList.first(where: { $0.matchPath == path })?.routeBuild(rootNavigator, item.items, dependency)
    }

    controller.setViewControllers(controller.viewControllers + newItemList, animated: isAnimated)
  }

  func back(isAnimated: Bool) {
    guard controller.viewControllers.count > 1 else { return }
    controller.popViewController(animated: isAnimated)
  }

  func backOrNext<Root>(
    rootNavigator: Root,
    item: LinkItem,
    isAnimated: Bool,
    routeBuilderList: [RouteBuilderOf<Root>],
    dependency: DependencyType)
  {
    if let pick = find(path: item.paths.first ?? "") {
      controller.popToViewController(pick, animated: isAnimated)
      return
    }
    push(rootNavigator: rootNavigator, item: item, isAnimated: isAnimated, routeBuilderList: routeBuilderList, dependency: dependency)
  }

  func remove(item: LinkItem) {
    let new = viewControllers.filter{ item.paths.contains($0.matchPath) }
    guard new.count != viewControllers.count else { return }
    controller.setViewControllers(new, animated: false)
  }

  func backToLast(item: LinkItem, isAnimated: Bool) {
    guard let path = item.paths.first else { return }
    guard let pick = viewControllers.last(where: { $0.matchPath == path }) else { return }
    controller.popToViewController(pick, animated: isAnimated)
  }

  func find(path: String) -> MatchingViewController? {
    controller.viewControllers
      .compactMap { $0 as? MatchingViewController }
      .first(where: { $0.matchPath == path })
  }

  func reset(isAnimated: Bool = false) {
    controller.setViewControllers([], animated: isAnimated)
  }
}

// MARK: Equatable

extension Navigator: Equatable {
  public static func == (lhs: Navigator, rhs: Navigator) -> Bool {
    lhs.controller === rhs.controller
  }
}
