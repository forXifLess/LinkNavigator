import UIKit

// MARK: - TabLinkNavigator

public final class TabLinkNavigator {

  // MARK: Lifecycle

  public init(
    linkPath: String,
    tabController: UITabBarController = .init(),
    tabItemList: [TabBarNavigator],
    routeBuilderItemList: [RouteBuilderOf<TabLinkNavigator>],
    dependency: DependencyType,
    defaultTagPath: String)
  {
    self.linkPath = linkPath
    self.tabController = tabController
    self.tabItemList = tabItemList
    self.routeBuilderItemList = routeBuilderItemList
    self.dependency = dependency
    self.defaultTagPath = defaultTagPath
  }

  // MARK: Public

  public let linkPath: String
  public let tabItemList: [TabBarNavigator]
  public let routeBuilderItemList: [RouteBuilderOf<TabLinkNavigator>]
  public let dependency: DependencyType
  public let defaultTagPath: String
  public let tabController: UITabBarController

  public var subNavigator: Navigator?

  // MARK: Private

  private var coordinate: Coordinate = .init(sheetDidDismiss: { })

}

extension TabLinkNavigator {

  public func launch(isTabBarHidden: Bool = false) -> BaseViewController {
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
    return .init(viewController: tabController)
  }
}

// MARK: LinkNavigatorProtocol

extension TabLinkNavigator: LinkNavigatorProtocol {
  public var rootNavigator: Navigator {
    focusNavigatorTabItem ?? .init(initialLinkItem: .init(path: ""))
  }

  public var currentPaths: [String] {
    isSubNavigatorActive ? subNavigatorCurrentPaths : rootCurrentPaths
  }

  public var rootCurrentPaths: [String] {
    focusItemCurrentPath
  }

  public func next(linkItem: LinkItem, isAnimated: Bool) {
    activeNavigator?.push(
      rootNavigator: self,
      item: linkItem,
      isAnimated: isAnimated,
      routeBuilderList: routeBuilderItemList,
      dependency: dependency)
  }

  public func rootNext(linkItem: LinkItem, isAnimated: Bool) {
    focusNavigatorTabItem?.push(
      rootNavigator: self,
      item: linkItem,
      isAnimated: isAnimated,
      routeBuilderList: routeBuilderItemList,
      dependency: dependency)
  }

  public func sheet(linkItem: LinkItem, isAnimated: Bool) {
    sheetOpen(item: linkItem, isAnimated: isAnimated)
  }

  public func fullSheet(linkItem: LinkItem, isAnimated: Bool, prefersLargeTitles: Bool?) {
    sheetOpen(
      item: linkItem,
      isAnimated: isAnimated,
      prefersLargeTitles: prefersLargeTitles,
      presentWillAction: {
        $0.modalPresentationStyle = .fullScreen
      },
      presentDidAction: {[weak self] in
        $0.presentationController?.delegate = self?.coordinate
      })
  }

  public func customSheet(
    linkItem: LinkItem,
    isAnimated: Bool,
    iPhonePresentationStyle: UIModalPresentationStyle,
    iPadPresentationStyle: UIModalPresentationStyle,
    prefersLargeTitles: Bool?)
  {
    sheetOpen(
      item: linkItem,
      isAnimated: isAnimated,
      prefersLargeTitles: prefersLargeTitles,
      presentWillAction: {
        $0.modalPresentationStyle = UIDevice.current.userInterfaceIdiom == .phone
          ? iPhonePresentationStyle
          : iPadPresentationStyle
      },
      presentDidAction: {[weak self] in
        $0.presentationController?.delegate = self?.coordinate
      })
  }

  public func replace(linkItem: LinkItem, isAnimated: Bool) {
    tabController.dismiss(animated: isAnimated) { [weak self] in
      guard let self else { return }
      subNavigator?.reset(isAnimated: isAnimated)
      subNavigator?.controller.presentationController?.delegate = .none
    }
    focusNavigatorTabItem?.replace(
      rootNavigator: self,
      item: linkItem,
      isAnimated: isAnimated,
      routeBuilderList: routeBuilderItemList,
      dependency: dependency)
  }

  public func backOrNext(linkItem: LinkItem, isAnimated: Bool) {
    activeNavigator?.backOrNext(
      rootNavigator: self,
      item: linkItem,
      isAnimated: isAnimated,
      routeBuilderList: routeBuilderItemList, dependency: dependency)
  }

  public func rootBackOrNext(linkItem: LinkItem, isAnimated: Bool) {
    guard let path = linkItem.pathList.first else { return }
    guard let pick = focusNavigatorTabItem?.viewControllers.first(where: { $0.matchPath == path }) else {
      focusNavigatorTabItem?.push(
        rootNavigator: self,
        item: .init(path: path, items: linkItem.items),
        isAnimated: isAnimated,
        routeBuilderList: routeBuilderItemList,
        dependency: dependency)
      return
    }
    focusNavigatorTabItem?.controller.popToViewController(pick, animated: isAnimated)
  }

  public func back(isAnimated: Bool) {
    isSubNavigatorActive
      ? sheetBack(isAnimated: isAnimated)
      : focusNavigatorTabItem?.back(isAnimated: isAnimated)
  }

  public func remove(pathList: [String]) {
    activeNavigator?.remove(item: .init(pathList: pathList))
  }

  public func rootRemove(pathList: [String]) {
    focusNavigatorTabItem?.remove(item: .init(pathList: pathList))
  }

  public func backToLast(path: String, isAnimated: Bool) {
    activeNavigator?.backToLast(item: .init(path: path), isAnimated: isAnimated)
  }

  public func rootBackToLast(path: String, isAnimated: Bool) {
    focusNavigatorTabItem?.backToLast(item: .init(path: path), isAnimated: isAnimated)
  }

  public func close(isAnimated: Bool, completeAction: @escaping () -> Void) {
    guard activeNavigator == subNavigator else { return }
    guard let focusNavigatorTabItem else { return }
    focusNavigatorTabItem.controller.dismiss(animated: isAnimated) { [weak self] in
      completeAction()
      self?.subNavigator?.reset()
      self?.subNavigator?.controller.presentationController?.delegate = .none
    }
  }

  public func range(path: String) -> [String] {
    currentPaths.reduce([String]()) { current, next in
      guard current.contains(path) else { return current + [next] }
      return current
    }
  }

  public func rootReloadLast(items: [String: String], isAnimated: Bool) {
    guard let focusNavigatorTabItem else { return }
    guard let lastPath = currentPaths.last else { return }
    guard let new = routeBuilderItemList.first(where: { $0.matchPath == lastPath })?.routeBuild(self, items, dependency)
    else { return }

    let newList = Array(focusNavigatorTabItem.controller.viewControllers.dropLast()) + [new]
    focusNavigatorTabItem.controller.setViewControllers(newList, animated: isAnimated)
  }

  public func alert(target: NavigationTarget, model: Alert) {
    guard let focusNavigatorTabItem else { return }
    switch target {
    case .default:
      alert(target: isSubNavigatorActive ? .sub : .root, model: model)
    case .root:
      focusNavigatorTabItem.controller.present(model.build(), animated: true)
    case .sub:
      subNavigator?.controller.present(model.build(), animated: true)
    }
  }
}

// MARK: TabNavigatorType

extension TabLinkNavigator: TabNavigatorType {
  public func moveToTab(tagPath: String) {
    guard let pick = tabController.viewControllers?.first(where: { $0.tabBarItem.tag == tagPath.hashValue }) else { return }
    tabController.selectedViewController = pick
  }
}

extension TabLinkNavigator {

  public var isSubNavigatorActive: Bool {
    tabController.presentedViewController != .none
  }

  public var activeNavigator: Navigator? {
    guard let subNavigator else { return focusNavigatorTabItem }
    return isSubNavigatorActive ? subNavigator : focusNavigatorTabItem
  }
}

/// MARK: SubNavigator

extension TabLinkNavigator {

  // MARK: Public

  public func sheetOpen(
    item: LinkItem,
    isAnimated: Bool,
    prefersLargeTitles: Bool? = .none,
    presentWillAction: @escaping (UINavigationController) -> Void = { _ in },
    presentDidAction: @escaping (UINavigationController) -> Void = { _ in })
  {
    tabController.dismiss(animated: true)

    let new = Navigator(initialLinkItem: item)
    if let prefersLargeTitles { new.controller.navigationBar.prefersLargeTitles = prefersLargeTitles }
    presentWillAction(new.controller)

    new.replace(
      rootNavigator: self,
      item: item,
      isAnimated: false,
      routeBuilderList: routeBuilderItemList,
      dependency: dependency)
    focusNavigatorTabItem?.controller.present(new.controller, animated: isAnimated)
    presentDidAction(new.controller)

    subNavigator = new
  }

  // MARK: Private

  private var subNavigatorCurrentPaths: [String] {
    subNavigator?.currentPath ?? []
  }

  private func sheetBack(isAnimated: Bool) {
    guard let subNavigator else { return }
    guard subNavigator.viewControllers.count > 1 else {
      tabController.dismiss(animated: true)
      self.subNavigator = .none
      return
    }
    subNavigator.back(isAnimated: isAnimated)
  }
}

/// MARK: MainNavigator

extension TabLinkNavigator {

  private var focusNavigatorTabItem: Navigator? {
    guard let select = tabController.selectedViewController else { return .none }
    return tabItemList.first(where: { $0.navigator.controller == select })?.navigator
  }

  private var focusItemCurrentPath: [String] {
    focusNavigatorTabItem?.currentPath ?? []
  }
}

// MARK: TabLinkNavigator.Coordinate

extension TabLinkNavigator {
  fileprivate class Coordinate: NSObject, UIAdaptivePresentationControllerDelegate {

    // MARK: Lifecycle

    init(sheetDidDismiss: @escaping () -> Void) {
      self.sheetDidDismiss = sheetDidDismiss
    }

    // MARK: Internal

    var sheetDidDismiss: () -> Void

    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
      sheetDidDismiss()
    }
  }
}
