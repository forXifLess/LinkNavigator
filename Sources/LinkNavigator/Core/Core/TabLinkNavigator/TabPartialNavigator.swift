import Foundation
import UIKit

// MARK: - TabPartialNavigator

public final class TabPartialNavigator {

  // MARK: Lifecycle

  public init(
    rootNavigator: TabLinkNavigator?,
    tabItem: TabItem,
    routeBuilderItemList: [RouteBuilderOf<TabPartialNavigator>],
    dependency: DependencyType)
  {
    self.rootNavigator = rootNavigator
    self.tabItem = tabItem
    self.routeBuilderItemList = routeBuilderItemList
    self.dependency = dependency
  }

  // MARK: Public

  public let tabItem: TabItem
  public let routeBuilderItemList: [RouteBuilderOf<TabPartialNavigator>]
  public let dependency: DependencyType

  public var owner: LinkNavigatorItemSubscriberProtocol? = .none

  public var currentTabNavigationController: UINavigationController { currentTabPathableController.navigationController }

  public var isFocusedCurrentTab: Bool {
    (currentTabNavigationController as? MatchPathUsable)?.matchPath == rootNavigator?.currentTabRootPath
  }

  // MARK: Private

  private var currentTabPathableController: TabRootNavigationController = .init(matchPath: "")

  private weak var rootNavigator: TabLinkNavigator?
  private lazy var navigationBuilder: TabNavigationBuilder<TabPartialNavigator> = .init(
    rootNavigator: self,
    routeBuilderList: routeBuilderItemList,
    dependency: dependency)

  private var currentController: UINavigationController? {
    rootNavigator?.modalController ?? rootNavigator?.fullSheetController ?? currentTabNavigationController
  }
}

extension TabPartialNavigator {
  public func launch(
    rootPath: String,
    item: LinkItem? = .none,
    prefersLargeTitles _: Bool = false)
    -> TabRootNavigationController
  {
    let viewControllers = navigationBuilder.build(item: item ?? tabItem.linkItem)

    currentTabPathableController.matchPath = rootPath
    currentTabPathableController.navigationController.setViewControllers(viewControllers, animated: false)
    currentTabPathableController.navigationController.delegate = currentTabPathableController.navigationController
    return currentTabPathableController
  }
}

// MARK: LinkNavigatorFindLocationUsable

extension TabPartialNavigator: LinkNavigatorFindLocationUsable {
  public func getCurrentPaths() -> [String] {
    currentController?.currentItemList() ?? []
  }

  public func getCurrentRootPaths() -> [String] {
    currentTabNavigationController.currentItemList()
  }
}

// MARK: TabLinkNavigatorProtocol

extension TabPartialNavigator: TabLinkNavigatorProtocol {
  public func next(linkItem: LinkItem, isAnimated: Bool) {
    currentController?.merge(
      new: navigationBuilder.build(item: linkItem),
      isAnimated: isAnimated)
  }

  public func rootNext(linkItem: LinkItem, isAnimated: Bool) {
    currentTabNavigationController.merge(
      new: navigationBuilder.build(item: linkItem),
      isAnimated: isAnimated)
  }

  public func back(isAnimated: Bool) {
    currentController?.back(isAnimated: isAnimated)
  }

  public func rootBack(isAnimated: Bool) {
    currentTabNavigationController.back(isAnimated: isAnimated)
  }

  public func backOrNext(linkItem: LinkItem, isAnimated: Bool) {
    guard
      navigationBuilder.isContainSequence(item: linkItem),
      let pick = navigationBuilder.lastPick(
        controller: currentController,
        item: linkItem)
    else {
      currentController?.merge(new: navigationBuilder.build(item: linkItem), isAnimated: isAnimated)
      return
    }
    currentController?.popToViewController(pick, animated: isAnimated)
  }

  public func rootBackOrNext(linkItem: LinkItem, isAnimated: Bool) {
    guard
      navigationBuilder.isContainSequence(item: linkItem),
      let pick = navigationBuilder.lastPick(
        controller: currentTabNavigationController,
        item: linkItem)
    else {
      currentTabNavigationController.merge(new: navigationBuilder.build(item: linkItem), isAnimated: isAnimated)
      return
    }
    currentTabNavigationController.popToViewController(pick, animated: isAnimated)
  }

  public func replace(linkItem: LinkItem, isAnimated: Bool) {
    let viewControllers = navigationBuilder.build(item: linkItem)
    guard !viewControllers.isEmpty else { return }

    currentController?.replace(
      viewController: viewControllers,
      isAnimated: isAnimated)
  }

  public func rootReplace(linkItem: LinkItem, isAnimated: Bool, closeAll: Bool = true) {
    let viewControllers = navigationBuilder.build(item: linkItem)
    guard !viewControllers.isEmpty else { return }

    currentTabNavigationController.replace(
      viewController: viewControllers,
      isAnimated: isAnimated)

    if closeAll {
      rootNavigator?.closeAll(isAnimated: isAnimated, completion: { })
    }
  }

  public func remove(pathList: [String]) {
    currentController?.setViewControllers(
      navigationBuilder.exceptFilter(
        controller: currentController,
        item: .init(pathList: pathList)),
      animated: false)
  }

  public func rootRemove(pathList: [String]) {
    currentTabNavigationController.setViewControllers(
      navigationBuilder.exceptFilter(
        controller: currentTabNavigationController,
        item: .init(pathList: pathList)),
      animated: false)
  }

  public func backToLast(path: String, isAnimated: Bool) {
    currentController?.popTo(
      viewController: navigationBuilder.lastPick(
        controller: currentController,
        item: .init(path: path)),
      isAnimated: isAnimated)
  }

  public func rootBackToLast(path: String, isAnimated: Bool) {
    currentTabNavigationController.popTo(
      viewController: navigationBuilder.lastPick(
        controller: currentTabNavigationController,
        item: .init(path: path)),
      isAnimated: isAnimated)
  }

  public func range(path: String) -> [String] {
    getCurrentRootPaths().reduce([String]()) { current, next in
      guard current.contains(path) else { return current + [next] }
      return current
    }
  }

  public func sheetOpen(
    item: LinkItem,
    isAnimated: Bool,
    type: UIModalPresentationStyle = .automatic)
  {
    let newController = UINavigationController()

    newController.setViewControllers(navigationBuilder.build(item: item), animated: false)

    rootNavigator?.sheetOpen(
      subViewController: newController,
      isAnimated: isAnimated,
      type: type,
      presentWillAction: {
        $0.modalPresentationStyle = type
      })
  }

  public func close(isAnimated: Bool, completeAction: () -> Void = { }) {
    rootNavigator?.close(isAnimated: isAnimated, completion: completeAction)
  }

  public func closeAll(isAnimated: Bool, completion: () -> Void = { }) {
    rootNavigator?.closeAll(isAnimated: isAnimated, completion: completion)
  }

  public func sheet(linkItem: LinkItem, isAnimated: Bool) {
    sheetOpen(item: linkItem, isAnimated: isAnimated, type: .automatic)
  }

  public func fullSheet(linkItem: LinkItem, isAnimated: Bool, prefersLargeTitles _: Bool?) {
    sheetOpen(item: linkItem, isAnimated: isAnimated, type: .fullScreen)
  }

  public func customSheet(
    linkItem: LinkItem,
    isAnimated: Bool,
    iPhonePresentationStyle: UIModalPresentationStyle,
    iPadPresentationStyle: UIModalPresentationStyle,
    prefersLargeTitles _: Bool?)
  {
    let type = UIDevice.current.userInterfaceIdiom == .phone ? iPhonePresentationStyle : iPadPresentationStyle
    sheetOpen(item: linkItem, isAnimated: isAnimated, type: type)
  }

  public func reloadLast(linkItem: LinkItem, isAnimated: Bool) {
    let viewControllers = navigationBuilder.build(item: linkItem)
    guard !viewControllers.isEmpty else { return }

    let reloadedVC = viewControllers.reduce(currentController?.viewControllers ?? []) { current, next in
      guard let idx = current.firstIndex(where: { ($0 as? MatchPathUsable)?.matchPath == next.matchPath }) else { return current }
      var variableCurrentVC = current
      variableCurrentVC[idx] = next
      return variableCurrentVC
    }

    currentController?.setViewControllers(reloadedVC, animated: isAnimated)
  }

  public func rootReloadLast(linkItem: LinkItem, isAnimated: Bool) {
    let viewControllers = navigationBuilder.build(item: linkItem)
    guard !viewControllers.isEmpty else { return }

    let reloadedVC = viewControllers.reduce(currentTabNavigationController.viewControllers) { current, next in
      guard let idx = current.firstIndex(where: { ($0 as? MatchPathUsable)?.matchPath == next.matchPath }) else { return current }
      var variableCurrentVC = current
      variableCurrentVC[idx] = next
      return variableCurrentVC
    }

    currentTabNavigationController.setViewControllers(reloadedVC, animated: isAnimated)
  }

  public func alert(target _: NavigationTarget, model: Alert) {
    currentController?.present(model.build(), animated: true)
  }

  public func send(targetTabPath: String?, linkItem: LinkItem) {
    var matchPathUsables: [MatchPathUsable] = []

    if let targetTabPath {
      matchPathUsables = rootNavigator?
        .targetController(targetTabPath: targetTabPath)?.viewControllers
        .compactMap { $0 as? MatchPathUsable } ?? []
    } else {
      matchPathUsables = rootNavigator?.tabRootNavigators
        .flatMap(\.navigationController.viewControllers)
        .compactMap { $0 as? MatchPathUsable } ?? []
    }

    matchPathUsables
      .filter { linkItem.pathList.contains($0.matchPath) }
      .forEach {
        $0.eventSubscriber?.receive(encodedItemString: linkItem.encodedItemString)
      }
  }

  public func currentTabSend(linkItem: LinkItem) {
    currentTabNavigationController.viewControllers
      .compactMap { $0 as? MatchPathUsable }
      .filter { linkItem.pathList.contains($0.matchPath) }
      .forEach {
        $0.eventSubscriber?.receive(encodedItemString: linkItem.encodedItemString)
      }
  }

  public func mainSend(linkItem: LinkItem) {
    guard let owner else { return }
    DispatchQueue.main.async {
      owner.receive(encodedItemString: linkItem.encodedItemString)
    }
  }

  public func allSend(linkItem: LinkItem) {
    rootNavigator?.tabRootNavigators
      .flatMap(\.navigationController.viewControllers)
      .compactMap { $0 as? MatchPathUsable }
      .forEach {
        $0.eventSubscriber?.receive(encodedItemString: linkItem.encodedItemString)
      }
  }

  public func currentTabAllSend(linkItem: LinkItem) {
    currentTabNavigationController.viewControllers
      .compactMap { ($0 as? MatchPathUsable)?.eventSubscriber }
      .forEach {
        $0.receive(encodedItemString: linkItem.encodedItemString)
      }
  }

  public func moveTab(path: String) {
    rootNavigator?.moveTab(targetPath: path)
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

// MARK: - UINavigationController + UINavigationControllerDelegate

extension UINavigationController: UINavigationControllerDelegate {
  public func navigationController(_: UINavigationController, didShow viewController: UIViewController, animated _: Bool) {
    guard let matchPathUsableVC = viewController as? MatchPathUsable else { return }

    NotificationCenter.default
      .post(name: TabbarEventNotification.onMoved, object: matchPathUsableVC.matchPath)
  }
}
