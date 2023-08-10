import UIKit
import SwiftUI

public final class Navigator {

  public typealias ViewControllerType = UIViewController & MatchPathUsable

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
  var viewControllers: [ViewControllerType] {
    controller.viewControllers.compactMap { $0 as? ViewControllerType }
  }
}

extension Navigator {
  func replace<Navigator>(rootNavigator: Navigator, item: LinkItem, isAnimated: Bool, routeBuilderList: [RouteBuilderOf<Navigator>], dependency: DependencyType) {
    let newItemList = item.paths.compactMap { path in
      routeBuilderList.first(where: { $0.matchPath == path })?.routeBuild(rootNavigator, item.items, dependency)
    }

    controller.setViewControllers(newItemList, animated: isAnimated)
  }

  func push<Navigator>(rootNavigator: Navigator, item: LinkItem, isAnimated: Bool, routeBuilderList: [RouteBuilderOf<Navigator>], dependency: DependencyType) {
    let newItemList = item.paths.compactMap { path in
      routeBuilderList.first(where: { $0.matchPath == path })?.routeBuild(rootNavigator, item.items, dependency)
    }

    controller.setViewControllers(controller.viewControllers + newItemList, animated: isAnimated)
  }

  func back(isAnimated: Bool) {
    guard controller.viewControllers.count > 1 else { return }
    controller.popViewController(animated: isAnimated)
  }

  func backOrNext(rootNavigator: Navigator, item: LinkItem, isAnimated: Bool, routeBuilderList: [RouteBuilderOf<Navigator>], dependency: DependencyType) {
    if let pick = find(path: item.paths.first ?? "") {
      controller.popToViewController(pick, animated: isAnimated)
      return
    }
    push(rootNavigator: rootNavigator, item: item, isAnimated: isAnimated, routeBuilderList: routeBuilderList, dependency: dependency)
  }

  func find(path: String) -> MatchingViewController? {
    controller.viewControllers
      .compactMap { $0 as? MatchingViewController }
      .first(where: { $0.matchPath  == path })
  }
}
