import UIKit

// MARK: - TabLinkNavigator

//// MARK: - TabLinkNavigator
//
public final class TabLinkNavigator<ItemValue: EmptyValueType> {

  // MARK: Lifecycle

  public init(
    routeBuilderItemList: [RouteBuilderOf<TabPartialNavigator<ItemValue>, ItemValue>],
    dependency: DependencyType,
    tabItems: [TabItem<ItemValue>])
  {
    self.routeBuilderItemList = routeBuilderItemList
    self.dependency = dependency
    self.tabItems = tabItems
  }

  // MARK: Public

  public let routeBuilderItemList: [RouteBuilderOf<TabPartialNavigator<ItemValue>, ItemValue>]
  public let dependency: DependencyType

  public var tabPartialNavigators: [TabPartialNavigator<ItemValue>] = []

  public let tabItems: [TabItem<ItemValue>]
  public var owner: LinkNavigatorSubscriberType? = .none

  public weak var mainController: UITabBarController?

  // MARK: Internal

  var modalController: UINavigationController? = .none
  var fullSheetController: UINavigationController? = .none
}

extension TabLinkNavigator {
  public func launch(tagItemList: [TabItem<ItemValue>]) -> [UINavigationController] {
    tabPartialNavigators = tagItemList
      .reduce([TabPartialNavigator<ItemValue>]()) { curr, next in
        let newNavigatorList = TabPartialNavigator(
          rootNavigator: self,
          tabItem: next,
          routeBuilderItemList: routeBuilderItemList,
          dependency: dependency)
        return curr + [newNavigatorList]
      }

    let navigationList = tabPartialNavigators
      .map {
        let nc = UINavigationController()
        nc.setViewControllers($0.launch(), animated: false)
        return nc
      }

    return navigationList
  }
}

extension TabLinkNavigator {
  public func sheetOpen(
    subViewController: UINavigationController,
    isAnimated: Bool,
    type: UIModalPresentationStyle,
    presentWillAction: @escaping (UINavigationController) -> Void = { _ in },
    presentDidAction: @escaping (UINavigationController) -> Void = { _ in })
  {
    if let fullSheetController {
      fullSheetController.dismiss(animated: true)
    } else {
      mainController?.dismiss(animated: true)
    }

    presentWillAction(subViewController)

    switch type {
    case .fullScreen, .overFullScreen:
      if let fullSheetController {
        subViewController.modalPresentationStyle = .formSheet
        fullSheetController.present(subViewController, animated: isAnimated)
        modalController = subViewController
      } else {
        mainController?.present(subViewController, animated: isAnimated)
        fullSheetController = subViewController
      }

    default:
      if let fullSheetController {
        fullSheetController.present(subViewController, animated: isAnimated)
      } else {
        mainController?.present(subViewController, animated: isAnimated)
      }
      modalController = subViewController
    }
    presentDidAction(subViewController)
  }

  public func close(isAnimated: Bool) {
    if let modalController {
      if let fullSheetController {
        fullSheetController.dismiss(animated: isAnimated)
      } else {
        mainController?.dismiss(animated: isAnimated)
      }
      self.modalController = .none
    } else if let fullSheetController {
      mainController?.dismiss(animated: isAnimated)
      self.fullSheetController = .none
    }
  }

  public func closeAll(isAnimated: Bool) {
    mainController?.dismiss(animated: isAnimated)
    modalController = .none
    fullSheetController = .none
  }

  public func moveTab(targetTag: String) {
    mainController?.selectedViewController = tabPartialNavigators.first(where: { $0.tabItem.tag == targetTag })?.rootController
  }
}

//
//  // MARK: Lifecycle
//
//  public init(
//    linkPath: String,
//    tabController: UITabBarController = .init(),
//    tabItemList: [TabBarNavigator<ItemValue>],
//    routeBuilderItemList: [RouteBuilderOf<TabLinkNavigator, ItemValue>],
//    dependency: DependencyType,
//    defaultTagPath: String)
//  {
//    self.linkPath = linkPath
//    self.tabController = tabController
//    self.tabItemList = tabItemList
//    self.routeBuilderItemList = routeBuilderItemList
//    self.dependency = dependency
//    self.defaultTagPath = defaultTagPath
//  }
//
//  // MARK: Public
//
//  public let linkPath: String
//  public let tabItemList: [TabBarNavigator<ItemValue>]
//  public let routeBuilderItemList: [RouteBuilderOf<TabLinkNavigator, ItemValue>]
//  public let dependency: DependencyType
//  public let defaultTagPath: String
//  public let tabController: UITabBarController
//
//  public var subNavigator: Navigator<ItemValue>?
//
//  // MARK: Private
//
//  private var coordinate: Coordinate = .init(sheetDidDismiss: { })
//
// }
//
// extension TabLinkNavigator {
//
//  public func launch(
//    prefersLargeTitles: Bool = false,
//    isTabBarHidden: Bool = false)
//    -> BaseViewController
//  {
//    defer { tabController.tabBar.isHidden = isTabBarHidden }
//    let newItemList = tabItemList.map { [weak self] current -> Navigator<ItemValue>? in
//      guard let self else { return .none }
//      current.navigator.replace(
//        rootNavigator: self,
//        item: current.navigator.initialLinkItem,
//        isAnimated: false,
//        routeBuilderList: routeBuilderItemList,
//        dependency: dependency)
//      current.navigator.controller.tabBarItem = current.tabBarItem
//      current.navigator.controller.navigationBar.prefersLargeTitles = prefersLargeTitles
//      return current.navigator
//    }.compactMap { $0 }
//
//    tabController.setViewControllers(newItemList.map(\.controller), animated: false)
//    moveToTab(tagPath: defaultTagPath)
//    return .init(viewController: tabController)
//  }
//
//  public var rootNavigator: Navigator<ItemValue> {
//    focusNavigatorTabItem ?? .init(initialLinkItem: .init(path: "", items: .empty))
//  }
//
//  public var currentPaths: [String] {
//    isSubNavigatorActive ? subNavigatorCurrentPaths : rootCurrentPaths
//  }
//
//  public var rootCurrentPaths: [String] {
//    focusItemCurrentPath
//  }
// }
//
// extension TabLinkNavigator {
//
//  private func _next(linkItem: LinkItem<ItemValue>, isAnimated: Bool) {
//    activeNavigator?.push(
//      rootNavigator: self,
//      item: linkItem,
//      isAnimated: isAnimated,
//      routeBuilderList: routeBuilderItemList,
//      dependency: dependency)
//  }
//
//  private func _rootNext(linkItem: LinkItem<ItemValue>, isAnimated: Bool) {
//    focusNavigatorTabItem?.push(
//      rootNavigator: self,
//      item: linkItem,
//      isAnimated: isAnimated,
//      routeBuilderList: routeBuilderItemList,
//      dependency: dependency)
//  }
//
//  private func _sheet(linkItem: LinkItem<ItemValue>, isAnimated: Bool) {
//    sheetOpen(item: linkItem, isAnimated: isAnimated)
//  }
//
//  private func _fullSheet(linkItem: LinkItem<ItemValue>, isAnimated: Bool, prefersLargeTitles: Bool?) {
//    sheetOpen(
//      item: linkItem,
//      isAnimated: isAnimated,
//      prefersLargeTitles: prefersLargeTitles,
//      presentWillAction: {
//        $0.modalPresentationStyle = .fullScreen
//      },
//      presentDidAction: { [weak self] in
//        $0.presentationController?.delegate = self?.coordinate
//      })
//  }
//
//  private func _customSheet(
//    linkItem: LinkItem<ItemValue>,
//    isAnimated: Bool,
//    iPhonePresentationStyle: UIModalPresentationStyle,
//    iPadPresentationStyle: UIModalPresentationStyle,
//    prefersLargeTitles: Bool?)
//  {
//    sheetOpen(
//      item: linkItem,
//      isAnimated: isAnimated,
//      prefersLargeTitles: prefersLargeTitles,
//      presentWillAction: {
//        $0.modalPresentationStyle = UIDevice.current.userInterfaceIdiom == .phone
//          ? iPhonePresentationStyle
//          : iPadPresentationStyle
//      },
//      presentDidAction: { [weak self] in
//        $0.presentationController?.delegate = self?.coordinate
//      })
//  }
//
//  private func _replace(linkItem: LinkItem<ItemValue>, isAnimated: Bool) {
//    tabController.dismiss(animated: isAnimated) { [weak self] in
//      guard let self else { return }
//      subNavigator?.reset(isAnimated: isAnimated)
//      subNavigator?.controller.presentationController?.delegate = .none
//    }
//    focusNavigatorTabItem?.replace(
//      rootNavigator: self,
//      item: linkItem,
//      isAnimated: isAnimated,
//      routeBuilderList: routeBuilderItemList,
//      dependency: dependency)
//  }
//
//  private func _backOrNext(linkItem: LinkItem<ItemValue>, isAnimated: Bool) {
//    activeNavigator?.backOrNext(
//      rootNavigator: self,
//      item: linkItem,
//      isAnimated: isAnimated,
//      routeBuilderList: routeBuilderItemList, dependency: dependency)
//  }
//
//  private func _rootBackOrNext(linkItem: LinkItem<ItemValue>, isAnimated: Bool) {
//    guard let path = linkItem.pathList.first else { return }
//    guard let pick = focusNavigatorTabItem?.viewControllers.first(where: { $0.matchPath == path }) else {
//      focusNavigatorTabItem?.push(
//        rootNavigator: self,
//        item: .init(path: path, items: linkItem.items),
//        isAnimated: isAnimated,
//        routeBuilderList: routeBuilderItemList,
//        dependency: dependency)
//      return
//    }
//    focusNavigatorTabItem?.controller.popToViewController(pick, animated: isAnimated)
//  }
//
//  private func _back(isAnimated: Bool) {
//    isSubNavigatorActive
//      ? sheetBack(isAnimated: isAnimated)
//      : focusNavigatorTabItem?.back(isAnimated: isAnimated)
//  }
//
//  private func _remove(pathList: [String]) {
//    activeNavigator?.remove(item: .init(pathList: pathList, items: .empty))
//  }
//
//  private func _rootRemove(pathList: [String]) {
//    focusNavigatorTabItem?.remove(item: .init(pathList: pathList, items: .empty))
//  }
//
//  private func _backToLast(path: String, isAnimated: Bool) {
//    activeNavigator?.backToLast(
//      item: .init(path: path, items: .empty),
//      isAnimated: isAnimated)
//  }
//
//  private func _rootBackToLast(path: String, isAnimated: Bool) {
//    focusNavigatorTabItem?.backToLast(
//      item: .init(path: path, items: .empty),
//      isAnimated: isAnimated)
//  }
//
//  private func _close(isAnimated: Bool, completeAction: @escaping () -> Void) {
//    guard activeNavigator == subNavigator else { return }
//    guard let focusNavigatorTabItem else { return }
//    focusNavigatorTabItem.controller.dismiss(animated: isAnimated) { [weak self] in
//      completeAction()
//      self?.subNavigator?.reset()
//      self?.subNavigator?.controller.presentationController?.delegate = .none
//    }
//  }
//
//  private func _range(path: String) -> [String] {
//    getCurrentPaths().reduce([String]()) { current, next in
//      guard current.contains(path) else { return current + [next] }
//      return current
//    }
//  }
//
//  private func _rootReloadLast(items: ItemValue, isAnimated: Bool) {
//    guard let focusNavigatorTabItem else { return }
//    guard let lastPath = getCurrentPaths().last else { return }
//    guard let new = routeBuilderItemList.first(where: { $0.matchPath == lastPath })?.routeBuild(self, items, dependency)
//    else { return }
//
//    let newList = Array(focusNavigatorTabItem.controller.viewControllers.dropLast()) + [new]
//    focusNavigatorTabItem.controller.setViewControllers(newList, animated: isAnimated)
//  }
//
//  private func _alert(target: NavigationTarget, model: Alert) {
//    guard let focusNavigatorTabItem else { return }
//    switch target {
//    case .default:
//      _alert(target: isSubNavigatorActive ? .sub : .root, model: model)
//    case .root:
//      focusNavigatorTabItem.controller.present(model.build(), animated: true)
//    case .sub:
//      subNavigator?.controller.present(model.build(), animated: true)
//    }
//  }
// }
//
//// MARK: TabNavigatorType
//
// extension TabLinkNavigator: TabNavigatorType {
//  public func moveToTab(tagPath: String) {
//    guard let pick = tabController.viewControllers?.first(where: { $0.tabBarItem.tag == tagPath.hashValue }) else { return }
//    tabController.selectedViewController = pick
//  }
// }
//
// extension TabLinkNavigator {
//
//  public var isSubNavigatorActive: Bool {
//    tabController.presentedViewController != .none
//  }
//
//  public var activeNavigator: Navigator<ItemValue>? {
//    guard let subNavigator else { return focusNavigatorTabItem }
//    return isSubNavigatorActive ? subNavigator : focusNavigatorTabItem
//  }
// }
//
///// MARK: SubNavigator
//
// extension TabLinkNavigator {
//
//  // MARK: Public
//
//  public func sheetOpen(
//    item: LinkItem<ItemValue>,
//    isAnimated: Bool,
//    prefersLargeTitles: Bool? = .none,
//    presentWillAction: @escaping (UINavigationController) -> Void = { _ in },
//    presentDidAction: @escaping (UINavigationController) -> Void = { _ in })
//  {
//    tabController.dismiss(animated: true)
//
//    let new = Navigator<ItemValue>(initialLinkItem: item)
//    if let prefersLargeTitles { new.controller.navigationBar.prefersLargeTitles = prefersLargeTitles }
//    presentWillAction(new.controller)
//
//    new.replace(
//      rootNavigator: self,
//      item: item,
//      isAnimated: false,
//      routeBuilderList: routeBuilderItemList,
//      dependency: dependency)
//    focusNavigatorTabItem?.controller.present(new.controller, animated: isAnimated)
//    presentDidAction(new.controller)
//
//    subNavigator = new
//  }
//
//  // MARK: Private
//
//  private var subNavigatorCurrentPaths: [String] {
//    subNavigator?.currentPath ?? []
//  }
//
//  private func sheetBack(isAnimated: Bool) {
//    guard let subNavigator else { return }
//    guard subNavigator.viewControllers.count > 1 else {
//      tabController.dismiss(animated: true)
//      self.subNavigator = .none
//      return
//    }
//    subNavigator.back(isAnimated: isAnimated)
//  }
// }
//
// extension TabLinkNavigator: LinkNavigatorFindLocationUsable {
//  public func getCurrentPaths() -> [String] {
//    isSubNavigatorActive ? subNavigatorCurrentPaths : getRootCurrentPaths()
//  }
//
//  public func getRootCurrentPaths() -> [String] {
//    rootNavigator.viewControllers.map(\.matchPath)
//  }
// }
//
// extension TabLinkNavigator: LinkNavigatorURLEncodedItemProtocol where ItemValue == String {
//  public func next(linkItem: LinkItem<ItemValue>, isAnimated: Bool) {
//    _next(linkItem: linkItem, isAnimated: isAnimated)
//  }
//
//  public func rootNext(linkItem: LinkItem<ItemValue>, isAnimated: Bool) {
//    _rootNext(linkItem: linkItem, isAnimated: isAnimated)
//  }
//
//  public func sheet(linkItem: LinkItem<ItemValue>, isAnimated: Bool) {
//    _sheet(linkItem: linkItem, isAnimated: isAnimated)
//  }
//
//  public func fullSheet(linkItem: LinkItem<ItemValue>, isAnimated: Bool, prefersLargeTitles: Bool?) {
//    _fullSheet(linkItem: linkItem, isAnimated: isAnimated, prefersLargeTitles: prefersLargeTitles)
//  }
//
//  public func customSheet(linkItem: LinkItem<ItemValue>, isAnimated: Bool, iPhonePresentationStyle: UIModalPresentationStyle, iPadPresentationStyle: UIModalPresentationStyle, prefersLargeTitles: Bool?) {
//    _customSheet(
//      linkItem: linkItem,
//      isAnimated: isAnimated,
//      iPhonePresentationStyle: iPhonePresentationStyle,
//      iPadPresentationStyle: iPadPresentationStyle,
//      prefersLargeTitles: prefersLargeTitles)
//  }
//
//  public func replace(linkItem: LinkItem<ItemValue>, isAnimated: Bool) {
//    _replace(linkItem: linkItem, isAnimated: isAnimated)
//  }
//
//  public func backOrNext(linkItem: LinkItem<ItemValue>, isAnimated: Bool) {
//    _backOrNext(linkItem: linkItem, isAnimated: isAnimated)
//  }
//
//  public func rootBackOrNext(linkItem: LinkItem<ItemValue>, isAnimated: Bool) {
//    _rootBackOrNext(linkItem: linkItem, isAnimated: isAnimated)
//  }
//
//  public func back(isAnimated: Bool) {
//    _back(isAnimated: isAnimated)
//  }
//
//  public func remove(pathList: [String]) {
//    _remove(pathList: pathList)
//  }
//
//  public func rootRemove(pathList: [String]) {
//    _rootRemove(pathList: pathList)
//  }
//
//  public func backToLast(path: String, isAnimated: Bool) {
//    _backToLast(path: path, isAnimated: isAnimated)
//  }
//
//  public func rootBackToLast(path: String, isAnimated: Bool) {
//    _rootBackToLast(path: path, isAnimated: isAnimated)
//  }
//
//  public func close(isAnimated: Bool, completeAction: @escaping () -> Void) {
//    _close(isAnimated: isAnimated, completeAction: completeAction)
//  }
//
//  public func range(path: String) -> [String] {
//    _range(path: path)
//  }
//
//  public func rootReloadLast(items: ItemValue, isAnimated: Bool) {
//    _rootReloadLast(items: items, isAnimated: isAnimated)
//  }
//
//  public func alert(target: NavigationTarget, model: Alert) {
//    _alert(target: target, model: model)
//  }
//
//
// }
//
// extension TabLinkNavigator: LinkNavigatorDictionaryItemProtocol where ItemValue == [String: String] {
//
//  public func apply(isRTL: Bool) {
//  }
//
//  public func next(linkItem: LinkItem<ItemValue>, isAnimated: Bool) {
//    _next(linkItem: linkItem, isAnimated: isAnimated)
//  }
//
//  public func rootNext(linkItem: LinkItem<ItemValue>, isAnimated: Bool) {
//    _rootNext(linkItem: linkItem, isAnimated: isAnimated)
//  }
//
//  public func sheet(linkItem: LinkItem<ItemValue>, isAnimated: Bool) {
//    _sheet(linkItem: linkItem, isAnimated: isAnimated)
//  }
//
//  public func fullSheet(linkItem: LinkItem<ItemValue>, isAnimated: Bool, prefersLargeTitles: Bool?) {
//    _fullSheet(linkItem: linkItem, isAnimated: isAnimated, prefersLargeTitles: prefersLargeTitles)
//  }
//
//  public func customSheet(linkItem: LinkItem<ItemValue>, isAnimated: Bool, iPhonePresentationStyle: UIModalPresentationStyle, iPadPresentationStyle: UIModalPresentationStyle, prefersLargeTitles: Bool?) {
//    _customSheet(
//      linkItem: linkItem,
//      isAnimated: isAnimated,
//      iPhonePresentationStyle: iPhonePresentationStyle,
//      iPadPresentationStyle: iPadPresentationStyle,
//      prefersLargeTitles: prefersLargeTitles)
//  }
//
//  public func replace(linkItem: LinkItem<ItemValue>, isAnimated: Bool) {
//    _replace(linkItem: linkItem, isAnimated: isAnimated)
//  }
//
//  public func backOrNext(linkItem: LinkItem<ItemValue>, isAnimated: Bool) {
//    _backOrNext(linkItem: linkItem, isAnimated: isAnimated)
//  }
//
//  public func rootBackOrNext(linkItem: LinkItem<ItemValue>, isAnimated: Bool) {
//    _rootBackOrNext(linkItem: linkItem, isAnimated: isAnimated)
//  }
//
//  public func back(isAnimated: Bool) {
//    _back(isAnimated: isAnimated)
//  }
//
//  public func remove(pathList: [String]) {
//    _remove(pathList: pathList)
//  }
//
//  public func rootRemove(pathList: [String]) {
//    _rootRemove(pathList: pathList)
//  }
//
//  public func backToLast(path: String, isAnimated: Bool) {
//    _backToLast(path: path, isAnimated: isAnimated)
//  }
//
//  public func rootBackToLast(path: String, isAnimated: Bool) {
//    _rootBackToLast(path: path, isAnimated: isAnimated)
//  }
//
//  public func close(isAnimated: Bool, completeAction: @escaping () -> Void) {
//    _close(isAnimated: isAnimated, completeAction: completeAction)
//  }
//
//  public func range(path: String) -> [String] {
//    _range(path: path)
//  }
//
//  public func rootReloadLast(items: ItemValue, isAnimated: Bool) {
//    _rootReloadLast(items: items, isAnimated: isAnimated)
//  }
//
//  public func alert(target: NavigationTarget, model: Alert) {
//    _alert(target: target, model: model)
//  }
//
//
// }
//
///// MARK: MainNavigator
//
// extension TabLinkNavigator {
//
//  private var focusNavigatorTabItem: Navigator<ItemValue>? {
//    guard let select = tabController.selectedViewController else { return .none }
//    return tabItemList.first(where: { $0.navigator.controller == select })?.navigator
//  }
//
//  private var focusItemCurrentPath: [String] {
//    focusNavigatorTabItem?.currentPath ?? []
//  }
// }
//
//// MARK: TabLinkNavigator.Coordinate
//
// extension TabLinkNavigator {
//  fileprivate class Coordinate: NSObject, UIAdaptivePresentationControllerDelegate {
//
//    // MARK: Lifecycle
//
//    init(sheetDidDismiss: @escaping () -> Void) {
//      self.sheetDidDismiss = sheetDidDismiss
//    }
//
//    // MARK: Internal
//
//    var sheetDidDismiss: () -> Void
//
//    func presentationControllerDidDismiss(_: UIPresentationController) {
//      sheetDidDismiss()
//    }
//  }
// }

extension UINavigationController {
  private func currentItemList() -> [String] {
    viewControllers.compactMap { $0 as? MatchPathUsable }.map(\.matchPath)
  }

  private func merge(new: [UIViewController], isAnimated: Bool) {
    setViewControllers(viewControllers + new, animated: isAnimated)
  }

  private func back(isAnimated: Bool) {
    popViewController(animated: isAnimated)
  }

  private func clear(isAnimated: Bool) {
    setViewControllers([], animated: isAnimated)
  }

  private func push(viewController: UIViewController?, isAnimated: Bool) {
    guard let viewController else { return }
    pushViewController(viewController, animated: isAnimated)
  }

  private func replace(viewController: [UIViewController], isAnimated: Bool) {
    setViewControllers(viewController, animated: isAnimated)
  }

  private func popTo(viewController: UIViewController?, isAnimated: Bool) {
    guard let viewController else { return }
    popToViewController(viewController, animated: isAnimated)
  }

  private func dropLast() -> [UIViewController] {
    Array(viewControllers.dropLast())
  }
}
