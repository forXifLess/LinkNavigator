import Foundation
import UIKit

// MARK: - TabPartialNavigator

public final class TabPartialNavigator<ItemValue: EmptyValueType> {

  // MARK: Lifecycle

  public init(
    rootNavigator: TabLinkNavigator<ItemValue>?,
    tabItem: TabItem<ItemValue>,
    routeBuilderItemList: [RouteBuilderOf<TabPartialNavigator, ItemValue>],
    dependency: DependencyType)
  {
    self.rootNavigator = rootNavigator
    self.tabItem = tabItem
    self.routeBuilderItemList = routeBuilderItemList
    self.dependency = dependency
  }

  // MARK: Public

  public let tabItem: TabItem<ItemValue>
  public let routeBuilderItemList: [RouteBuilderOf<TabPartialNavigator, ItemValue>]
  public let dependency: DependencyType

  public var rootController: UINavigationController = .init()

  public var isFocusedCurrentTab: Bool {
    rootNavigator?.tabPartialNavigators.first(where: { $0.rootController == rootController })?.tabItem.tag == tabItem.tag
  }

  // MARK: Private

  private weak var rootNavigator: TabLinkNavigator<ItemValue>?

  private var currentController: UINavigationController? {
    rootNavigator?.modalController != .none
      ? rootNavigator?.modalController
      : rootNavigator?.fullSheetController != .none
        ? rootNavigator?.fullSheetController
        : rootController
  }
}

// MARK: LinkNavigatorFindLocationUsable

extension TabPartialNavigator: LinkNavigatorFindLocationUsable {
  public func getCurrentPaths() -> [String] {
    currentController?.currentItemList() ?? []
  }

  public func getRootCurrentPaths() -> [String] {
    rootController.currentItemList()
  }
}

extension TabPartialNavigator {
  public func moveTab(targetTag: String) {
    rootNavigator?.moveTab(targetTag: targetTag)
  }
}

extension TabPartialNavigator {

  public func launch(item: LinkItem<ItemValue>? = .none, prefersLargeTitles _: Bool = false) -> [UIViewController] {
    let viewControllers = NavigatorBuilder.build(
      rootNavigator: self,
      item: item ?? tabItem.linkItem,
      routeBuilderList: routeBuilderItemList,
      dependency: dependency)

    rootController.setViewControllers(viewControllers, animated: false)
    return viewControllers
  }

  public func next(linkItem: LinkItem<ItemValue>, isAnimated: Bool) {
    currentController?.merge(
      new: NavigatorBuilder.build(
        rootNavigator: self,
        item: linkItem,
        routeBuilderList: routeBuilderItemList,
        dependency: dependency),
      isAnimated: isAnimated)
  }

  public func rootNext(linkItem: LinkItem<ItemValue>, isAnimated: Bool) {
    rootController.merge(
      new: NavigatorBuilder.build(
        rootNavigator: self,
        item: linkItem,
        routeBuilderList: routeBuilderItemList,
        dependency: dependency),
      isAnimated: isAnimated)
  }

  public func back(isAnimated: Bool) {
    currentController?.back(isAnimated: isAnimated)
  }

  public func rootBack(isAnimated: Bool) {
    rootController.back(isAnimated: isAnimated)
  }

  public func backOrNext(linkItem: LinkItem<ItemValue>, isAnimated: Bool) {
    guard
      let pick = NavigatorBuilder.firstPick(
        controller: currentController,
        item: linkItem)
    else {
      return
    }

    currentController?.popToViewController(pick, animated: isAnimated)
  }

  public func rootBackOrNext(linkItem: LinkItem<ItemValue>, isAnimated: Bool) {
    guard
      let pick = NavigatorBuilder.firstPick(
        controller: currentController,
        item: linkItem)
    else {
      return
    }

    rootController.popToViewController(pick, animated: isAnimated)
  }

  public func replace(linkItem: LinkItem<ItemValue>, isAnimated: Bool) {
    currentController?.replace(
      viewController: NavigatorBuilder.build(
        rootNavigator: self,
        item: linkItem,
        routeBuilderList: routeBuilderItemList,
        dependency: dependency),
      isAnimated: isAnimated)
  }

  public func rootReplace(linkItem: LinkItem<ItemValue>, isAnimated: Bool) {
    rootController.replace(
      viewController: NavigatorBuilder.build(
        rootNavigator: self,
        item: linkItem,
        routeBuilderList: routeBuilderItemList,
        dependency: dependency),
      isAnimated: isAnimated)
  }

  public func remove(pathList: [String]) {
    currentController?.setViewControllers(
      NavigatorBuilder.exceptFilter(
        controller: currentController,
        item: .init(pathList: pathList, items: ItemValue.empty)),
      animated: false)
  }

  public func rootRemove(pathList: [String]) {
    rootController.setViewControllers(
      NavigatorBuilder.exceptFilter(
        controller: rootController,
        item: .init(pathList: pathList, items: ItemValue.empty)),
      animated: false)
  }

  public func backToLast(path: String, isAnimated: Bool) {
    currentController?.popTo(
      viewController: NavigatorBuilder.lastPick(
        controller: currentController,
        item: .init(path: path, items: ItemValue.empty)),
      isAnimated: isAnimated)
  }

  public func rootBackToLast(path: String, isAnimated: Bool) {
    rootController.popTo(
      viewController: NavigatorBuilder.lastPick(
        controller: rootController,
        item: .init(path: path, items: ItemValue.empty)),
      isAnimated: isAnimated)
  }

  public func range(path: String) -> [String] {
    getRootCurrentPaths().reduce([String]()) { current, next in
      guard current.contains(path) else { return current + [next] }
      return current
    }
  }

  public func sheetOpen(
    item: LinkItem<ItemValue>,
    isAnimated: Bool,
    type: UIModalPresentationStyle = .automatic)
  {
    let newController = UINavigationController()

    newController.setViewControllers(
      NavigatorBuilder
        .build(
          rootNavigator: self,
          item: item,
          routeBuilderList: routeBuilderItemList,
          dependency: dependency),
      animated: false)

    rootNavigator?.sheetOpen(
      subViewController: newController,
      isAnimated: isAnimated,
      type: type,
      presentWillAction: {
        $0.modalPresentationStyle = type
      })
  }

  public func close(isAnimated _: Bool) {
    rootNavigator?.close(isAnimated: true)
  }

  public func closeAll(isAnimated: Bool) {
    rootNavigator?.closeAll(isAnimated: isAnimated)
  }
}

extension UINavigationController {

  // MARK: Fileprivate

  fileprivate func currentItemList() -> [String] {
    viewControllers.compactMap { $0 as? MatchPathUsable }.map(\.matchPath)
  }

  fileprivate func merge(new: [UIViewController], isAnimated: Bool) {
    setViewControllers(viewControllers + new, animated: isAnimated)
  }

  fileprivate func back(isAnimated: Bool) {
    popViewController(animated: isAnimated)
  }

  fileprivate func replace(viewController: [UIViewController], isAnimated: Bool) {
    setViewControllers(viewController, animated: isAnimated)
  }

  fileprivate func popTo(viewController: UIViewController?, isAnimated: Bool) {
    guard let viewController else { return }
    popToViewController(viewController, animated: isAnimated)
  }

  // MARK: Private

  private func clear(isAnimated: Bool) {
    setViewControllers([], animated: isAnimated)
  }

  private func push(viewController: UIViewController?, isAnimated: Bool) {
    guard let viewController else { return }
    pushViewController(viewController, animated: isAnimated)
  }

  private func dropLast() -> [UIViewController] {
    Array(viewControllers.dropLast())
  }
}
