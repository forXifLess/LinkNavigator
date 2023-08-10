import UIKit

public final class TabNavigator {

  public let linkPath: String
  public let rootNavigator: Navigator
  public let tabItemList: [TabBarNavigator]
  public let routeBuilderItemList: [RouteBuilderOf<TabNavigator>]
  public let dependency: DependencyType
  public let defaultTagPath: String
  public let tabController: UITabBarController

  private var subNavigator: Navigator?

  public init(
    linkPath: String,
    tabController: UITabBarController = .init(),
    rootNavigator: Navigator,
    tabItemList: [TabBarNavigator],
    routeBuilderItemList: [RouteBuilderOf<TabNavigator>],
    dependency: DependencyType,
    defaultTagPath: String)
  {
    self.linkPath = linkPath
    self.tabController = tabController
    self.rootNavigator = rootNavigator
    self.tabItemList = tabItemList
    self.routeBuilderItemList = routeBuilderItemList
    self.dependency = dependency
    self.defaultTagPath = defaultTagPath
  }
}

extension TabNavigator {

  public func launch(isTabBarHidden: Bool = false) -> BaseNavigator {
    defer { tabController.tabBar.isHidden = isTabBarHidden }
    let newItemList = tabItemList.map { [weak self] item -> Navigator? in
      guard let self else { return .none }
      item.navigator.replace(
        rootNavigator: self,
        item: item.navigator.initialLinkItem,
        isAnimated: false,
        routeBuilderList: routeBuilderItemList,
        dependency: dependency)
      item.navigator.controller.tabBarItem = item.tabBarItem
      return item.navigator
    }.compactMap { $0 }

    tabController.setViewControllers(newItemList.map(\.controller), animated: false)
    moveToTab(tagPath: defaultTagPath)
    rootNavigator.controller.setViewControllers([ tabController ], animated: false)
    return .init(viewController: rootNavigator.controller)
  }

  public func push(item: LinkItem, isAnimated: Bool) {
    isSubNavigatorActive
    ? sheetPush(item: item, isAnimated: isAnimated)
    : mainPush(item: item, isAnimated: isAnimated)
  }

  public func back(isAnimated: Bool) {
    isSubNavigatorActive
      ? sheetBack(isAnimated: isAnimated)
      : mainBack(isAnimated: isAnimated)
  }

  public func moveToTab(tagPath: String) {
    guard let pick = tabController.viewControllers?.first(where: { $0.tabBarItem.tag == tagPath.hashValue }) else { return }
    tabController.selectedViewController = pick
  }

  var currentTabPath: String? {
    (tabController.selectedViewController as? MatchPathUsable)?.matchPath
  }

  var focusNavigatorTabItem: Navigator? {
    guard let select = tabController.selectedViewController else { return .none }
    return tabItemList.first(where: { $0.navigator.controller == select })?.navigator
  }
}

extension TabNavigator {
  private func mainPush(item: LinkItem, isAnimated: Bool) {
    focusNavigatorTabItem?.push(
      rootNavigator: self,
      item: item,
      isAnimated: isAnimated,
      routeBuilderList: routeBuilderItemList,
      dependency: dependency)
  }

  private func mainBack(isAnimated: Bool) {
    focusNavigatorTabItem?.back(isAnimated: isAnimated)
  }
}



extension TabNavigator {

  public func sheet(item: LinkItem, isAnimated: Bool, prefersLargeTitles: Bool? = .none) {
    rootNavigator.controller.dismiss(animated: true)

    let new = Navigator(initialLinkItem: item)
    if let prefersLargeTitles { new.controller.navigationBar.prefersLargeTitles = prefersLargeTitles }

    new.replace(rootNavigator: self, item: item, isAnimated: false, routeBuilderList: routeBuilderItemList, dependency: dependency)
    rootNavigator.controller.present(new.controller, animated: isAnimated)

    self.subNavigator = new
  }

  var focusNavigator: Navigator {
    guard let subNavigator else { return rootNavigator }
    return isSubNavigatorActive ? subNavigator : rootNavigator
  }

  var isSubNavigatorActive: Bool {
    rootNavigator.controller.presentedViewController != .none
  }
}

extension TabNavigator {
  private func sheetPush(item: LinkItem, isAnimated: Bool) {
    subNavigator?.push(
      rootNavigator: self,
      item: item,
      isAnimated: isAnimated,
      routeBuilderList: routeBuilderItemList,
      dependency: dependency)
  }

  private func sheetBack(isAnimated: Bool) {
    guard let subNavigator else { return }
    guard subNavigator.viewControllers.count > 1 else {
      rootNavigator.controller.dismiss(animated: true)
      self.subNavigator = .none
      return
    }
    subNavigator.back(isAnimated: isAnimated)
  }
}

