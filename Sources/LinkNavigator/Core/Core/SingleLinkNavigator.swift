import Foundation
import UIKit

// MARK: - SingleLinkNavigator

public final class SingleLinkNavigator<ItemValue: EmptyValueType> {

  // MARK: Lifecycle

  public init(
    initialItem: LinkItem<ItemValue>? = .none,
    routeBuilderItemList: [RouteBuilderOf<SingleLinkNavigator, ItemValue>],
    dependency: DependencyType)
  {
    self.initialItem = initialItem ?? .init(path: .empty, items: .empty)
    self.routeBuilderItemList = routeBuilderItemList
    self.dependency = dependency
  }

  // MARK: Public

  public let routeBuilderItemList: [RouteBuilderOf<SingleLinkNavigator, ItemValue>]
  public let dependency: DependencyType

  public weak var rootController: UINavigationController?
  public var owner: LinkNavigatorSubscriberType? = .none
  public var subController: UINavigationController?

  // MARK: Private

  private var coordinate: Coordinate = .init(sheetDidDismiss: { })
  private let initialItem: LinkItem<ItemValue>

  private lazy var navigationBuilder: NavigationBuilder<SingleLinkNavigator, ItemValue> = .init(
    rootNavigator: self,
    routeBuilderList: routeBuilderItemList,
    dependency: dependency)

}

extension SingleLinkNavigator {

  // MARK: Public

  public func launch(item: LinkItem<ItemValue>? = .none, prefersLargeTitles _: Bool = false) -> [UIViewController] {
    navigationBuilder.build(item: item ?? initialItem)
  }

  // MARK: Private

  private var activeController: UINavigationController? {
    isSubNavigatorActive ? subController : rootController
  }
}

// MARK: LinkNavigatorFindLocationUsable

extension SingleLinkNavigator: LinkNavigatorFindLocationUsable {

  public func getCurrentPaths() -> [String] {
    isSubNavigatorActive ? subNavigatorCurrentPaths() : getRootCurrentPaths()
  }

  public func getRootCurrentPaths() -> [String] {
    guard let controller = rootController else { return [] }
    return controller.currentItemList()
  }

}

extension SingleLinkNavigator {

  private func _next(linkItem: LinkItem<ItemValue>, isAnimated: Bool) {
    guard let activeController else { return }
    activeController.merge(
      new: navigationBuilder.build(item: linkItem),
      isAnimated: isAnimated)
  }

  private func _rootNext(linkItem: LinkItem<ItemValue>, isAnimated: Bool) {
    guard let rootController else { return }

    rootController.merge(
      new: navigationBuilder.build(item: linkItem),
      isAnimated: isAnimated)
  }

  private func _sheet(linkItem: LinkItem<ItemValue>, isAnimated: Bool) {
    sheetOpen(item: linkItem, isAnimated: isAnimated)
  }

  private func _fullSheet(linkItem: LinkItem<ItemValue>, isAnimated: Bool, prefersLargeTitles: Bool?) {
    sheetOpen(
      item: linkItem,
      isAnimated: isAnimated,
      prefersLargeTitles: prefersLargeTitles,
      presentWillAction: {
        $0.modalPresentationStyle = .fullScreen
      },
      presentDidAction: { [weak self] in
        $0.presentationController?.delegate = self?.coordinate
      })
  }

  private func _customSheet(
    linkItem: LinkItem<ItemValue>,
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
      presentDidAction: { [weak self] in
        $0.presentationController?.delegate = self?.coordinate
      })
  }

  private func _replace(linkItem: LinkItem<ItemValue>, isAnimated: Bool) {
    guard let rootController else { return }

    rootController.dismiss(animated: isAnimated) { [weak self] in
      guard let self else { return }
      subController?.clear(isAnimated: isAnimated)
      subController?.presentationController?.delegate = .none
    }

    rootController.replace(
      viewController: navigationBuilder.build(item: linkItem),
      isAnimated: isAnimated)
  }

  private func _backOrNext(linkItem: LinkItem<ItemValue>, isAnimated: Bool) {
    guard let activeController else { return }

    guard let pick = navigationBuilder.firstPick(controller: activeController, item: linkItem) else {
      activeController.push(
        viewController: navigationBuilder.pickBuild(item: linkItem),
        isAnimated: isAnimated)
      return
    }

    activeController.popToViewController(pick, animated: isAnimated)
  }

  private func _rootBackOrNext(linkItem: LinkItem<ItemValue>, isAnimated: Bool) {
    guard let rootController else { return }

    guard let pick = navigationBuilder.firstPick(controller: rootController, item: linkItem) else {
      rootController.push(
        viewController: navigationBuilder.pickBuild(item: linkItem),
        isAnimated: isAnimated)
      return
    }

    rootController.popToViewController(pick, animated: isAnimated)
  }

  private func _back(isAnimated: Bool) {
    isSubNavigatorActive
      ? sheetBack(isAnimated: isAnimated)
      : rootController?.back(isAnimated: isAnimated)
  }

  private func _remove(pathList: [String]) {
    guard let activeController else { return }
    activeController.setViewControllers(
      navigationBuilder.exceptFilter(
        controller: activeController,
        item: .init(pathList: pathList, items: .empty)),
      animated: false)
  }

  private func _rootRemove(pathList: [String]) {
    guard let rootController else { return }
    rootController.setViewControllers(
      navigationBuilder.exceptFilter(
        controller: activeController,
        item: .init(pathList: pathList, items: .empty)),
      animated: false)
  }

  private func _backToLast(path: String, isAnimated: Bool) {
    activeController?.popTo(
      viewController: navigationBuilder.lastPick(
        controller: activeController,
        item: .init(path: path, items: .empty)),
      isAnimated: isAnimated)
  }

  private func _rootBackToLast(path: String, isAnimated: Bool) {
    rootController?.popTo(
      viewController: navigationBuilder.lastPick(
        controller: activeController,
        item: .init(path: path, items: .empty)),
      isAnimated: isAnimated)
  }

  private func _close(isAnimated: Bool, completeAction: @escaping () -> Void) {
    guard activeController == subController else { return }
    rootController?.dismiss(animated: isAnimated) { [weak self] in
      completeAction()
      self?.subController?.clear(isAnimated: false)
      self?.subController?.presentationController?.delegate = .none
    }
  }

  private func _range(path: String) -> [String] {
    getRootCurrentPaths().reduce([String]()) { current, next in
      guard current.contains(path) else { return current + [next] }
      return current
    }
  }

  private func _rootReloadLast(items: ItemValue, isAnimated _: Bool) {
    guard let lastPath = getRootCurrentPaths().last else { return }
    guard let rootController else { return }
    guard let new = routeBuilderItemList.first(where: { $0.matchPath == lastPath })?.routeBuild(self, items, dependency)
    else { return }

    let newList = rootController.dropLast() + [new]
    rootController.replace(viewController: newList, isAnimated: false)
  }

  private func _alert(target: NavigationTarget, model: Alert) {
    switch target {
    case .default:
      _alert(target: isSubNavigatorActive ? .sub : .root, model: model)
    case .root:
      rootController?.present(model.build(), animated: true)
    case .sub:
      subController?.present(model.build(), animated: true)
    }
  }
}

/// MARK: - Main
extension SingleLinkNavigator {
  public var isSubNavigatorActive: Bool {
    guard let controller = rootController else { return false }
    return controller.presentedViewController != .none
  }
}

/// MARK: - Sub
extension SingleLinkNavigator {

  // MARK: Public

  public func sheetOpen(
    item: LinkItem<ItemValue>,
    isAnimated: Bool,
    prefersLargeTitles: Bool? = .none,
    presentWillAction: @escaping (UINavigationController) -> Void = { _ in },
    presentDidAction: @escaping (UINavigationController) -> Void = { _ in })
  {
    guard let rootController else { return }

    rootController.dismiss(animated: true)
    let newController = UINavigationController()
    if let prefersLargeTitles { rootController.navigationBar.prefersLargeTitles = prefersLargeTitles }

    presentWillAction(newController)

    newController.setViewControllers(
      navigationBuilder.build(item: item),
      animated: false)

    rootController.present(newController, animated: isAnimated)
    presentDidAction(newController)

    subController = newController
  }

  // MARK: Private

  private func subNavigatorCurrentPaths() -> [String] {
    subController?.currentItemList() ?? []
  }

  private func sheetBack(isAnimated: Bool) {
    guard let rootController, let subController else { return }

    guard subController.viewControllers.count > 1 else {
      rootController.dismiss(animated: isAnimated) { [weak self] in
        self?.subController = .none
      }
      return
    }
    subController.back(isAnimated: isAnimated)
  }
}

// MARK: LinkNavigatorURLEncodedItemProtocol

extension SingleLinkNavigator: LinkNavigatorURLEncodedItemProtocol where ItemValue == String {
  public func next(linkItem: LinkItem<ItemValue>, isAnimated: Bool) {
    _next(linkItem: linkItem, isAnimated: isAnimated)
  }

  public func rootNext(linkItem: LinkItem<ItemValue>, isAnimated: Bool) {
    _rootNext(linkItem: linkItem, isAnimated: isAnimated)
  }

  public func sheet(linkItem: LinkItem<ItemValue>, isAnimated: Bool) {
    _sheet(linkItem: linkItem, isAnimated: isAnimated)
  }

  public func fullSheet(linkItem: LinkItem<ItemValue>, isAnimated: Bool, prefersLargeTitles: Bool?) {
    _fullSheet(linkItem: linkItem, isAnimated: isAnimated, prefersLargeTitles: prefersLargeTitles)
  }

  public func customSheet(
    linkItem: LinkItem<ItemValue>,
    isAnimated: Bool,
    iPhonePresentationStyle: UIModalPresentationStyle,
    iPadPresentationStyle: UIModalPresentationStyle,
    prefersLargeTitles: Bool?)
  {
    _customSheet(
      linkItem: linkItem,
      isAnimated: isAnimated,
      iPhonePresentationStyle: iPhonePresentationStyle,
      iPadPresentationStyle: iPadPresentationStyle,
      prefersLargeTitles: prefersLargeTitles)
  }

  public func replace(linkItem: LinkItem<ItemValue>, isAnimated: Bool) {
    _replace(linkItem: linkItem, isAnimated: isAnimated)
  }

  public func backOrNext(linkItem: LinkItem<ItemValue>, isAnimated: Bool) {
    _backOrNext(linkItem: linkItem, isAnimated: isAnimated)
  }

  public func rootBackOrNext(linkItem: LinkItem<ItemValue>, isAnimated: Bool) {
    _rootBackOrNext(linkItem: linkItem, isAnimated: isAnimated)
  }

  public func back(isAnimated: Bool) {
    _back(isAnimated: isAnimated)
  }

  public func remove(pathList: [String]) {
    _remove(pathList: pathList)
  }

  public func rootRemove(pathList: [String]) {
    _rootRemove(pathList: pathList)
  }

  public func backToLast(path: String, isAnimated: Bool) {
    _backToLast(path: path, isAnimated: isAnimated)
  }

  public func rootBackToLast(path: String, isAnimated: Bool) {
    _rootBackToLast(path: path, isAnimated: isAnimated)
  }

  public func close(isAnimated: Bool, completeAction: @escaping () -> Void) {
    _close(isAnimated: isAnimated, completeAction: completeAction)
  }

  public func range(path: String) -> [String] {
    _range(path: path)
  }

  public func rootReloadLast(items: ItemValue, isAnimated: Bool) {
    _rootReloadLast(items: items, isAnimated: isAnimated)
  }

  public func alert(target: NavigationTarget, model: Alert) {
    _alert(target: target, model: model)
  }

  public func send(item: LinkItem<ItemValue>) {
    activeController?.viewControllers.compactMap { $0 as? MatchPathUsable }
      .filter { item.pathList.contains($0.matchPath) }
      .forEach {
        guard case .urlEncoded(let subscriber) = $0.eventSubscriber
        else { return }
        subscriber.receive(item: item.items)
      }
  }

  public func rootSend(item: LinkItem<ItemValue>) {
    rootController?.viewControllers.compactMap { $0 as? MatchPathUsable }
      .filter { item.pathList.contains($0.matchPath) }
      .forEach {
        guard case .urlEncoded(let subscriber) = $0.eventSubscriber
        else { return }
        DispatchQueue.main.async {
          subscriber.receive(item: item.items)
        }
      }
  }

  public func mainSend(item: ItemValue) {
    guard let owner else { return }
    guard case .urlEncoded(let subscriber) = owner else { return }
    DispatchQueue.main.async {
      subscriber.receive(item: item)
    }
  }

  public func allSend(item: ItemValue) {
    activeController?.viewControllers.compactMap { $0 as? MatchPathUsable }
      .forEach {
        guard case .urlEncoded(let subscriber) = $0.eventSubscriber
        else { return }
        DispatchQueue.main.async {
          subscriber.receive(item: item)
        }
      }
  }

  public func allRootSend(item: ItemValue) {
    rootController?.viewControllers.compactMap { $0 as? MatchPathUsable }
      .forEach {
        guard case .urlEncoded(let subscriber) = $0.eventSubscriber
        else { return }
        DispatchQueue.main.async {
          subscriber.receive(item: item)
        }
      }
  }

}

// MARK: LinkNavigatorDictionaryItemProtocol

extension SingleLinkNavigator: LinkNavigatorDictionaryItemProtocol where ItemValue == [String: String] {
  public func next(linkItem: LinkItem<ItemValue>, isAnimated: Bool) {
    _next(linkItem: linkItem, isAnimated: isAnimated)
  }

  public func rootNext(linkItem: LinkItem<ItemValue>, isAnimated: Bool) {
    _rootNext(linkItem: linkItem, isAnimated: isAnimated)
  }

  public func sheet(linkItem: LinkItem<ItemValue>, isAnimated: Bool) {
    _sheet(linkItem: linkItem, isAnimated: isAnimated)
  }

  public func fullSheet(linkItem: LinkItem<ItemValue>, isAnimated: Bool, prefersLargeTitles: Bool?) {
    _fullSheet(linkItem: linkItem, isAnimated: isAnimated, prefersLargeTitles: prefersLargeTitles)
  }

  public func customSheet(
    linkItem: LinkItem<ItemValue>,
    isAnimated: Bool,
    iPhonePresentationStyle: UIModalPresentationStyle,
    iPadPresentationStyle: UIModalPresentationStyle,
    prefersLargeTitles: Bool?)
  {
    _customSheet(
      linkItem: linkItem,
      isAnimated: isAnimated,
      iPhonePresentationStyle: iPhonePresentationStyle,
      iPadPresentationStyle: iPadPresentationStyle,
      prefersLargeTitles: prefersLargeTitles)
  }

  public func replace(linkItem: LinkItem<ItemValue>, isAnimated: Bool) {
    _replace(linkItem: linkItem, isAnimated: isAnimated)
  }

  public func backOrNext(linkItem: LinkItem<ItemValue>, isAnimated: Bool) {
    _backOrNext(linkItem: linkItem, isAnimated: isAnimated)
  }

  public func rootBackOrNext(linkItem: LinkItem<ItemValue>, isAnimated: Bool) {
    _rootBackOrNext(linkItem: linkItem, isAnimated: isAnimated)
  }

  public func back(isAnimated: Bool) {
    _back(isAnimated: isAnimated)
  }

  public func remove(pathList: [String]) {
    _remove(pathList: pathList)
  }

  public func rootRemove(pathList: [String]) {
    _rootRemove(pathList: pathList)
  }

  public func backToLast(path: String, isAnimated: Bool) {
    _backToLast(path: path, isAnimated: isAnimated)
  }

  public func rootBackToLast(path: String, isAnimated: Bool) {
    _rootBackToLast(path: path, isAnimated: isAnimated)
  }

  public func close(isAnimated: Bool, completeAction: @escaping () -> Void) {
    _close(isAnimated: isAnimated, completeAction: completeAction)
  }

  public func range(path: String) -> [String] {
    _range(path: path)
  }

  public func rootReloadLast(items: ItemValue, isAnimated: Bool) {
    _rootReloadLast(items: items, isAnimated: isAnimated)
  }

  public func alert(target: NavigationTarget, model: Alert) {
    _alert(target: target, model: model)
  }

  public func send(item: LinkItem<ItemValue>) {
    activeController?.viewControllers.compactMap { $0 as? MatchPathUsable }
      .filter { item.pathList.contains($0.matchPath) }
      .forEach {
        guard case .dictionary(let subscriber) = $0.eventSubscriber
        else { return }
        subscriber.receive(item: item.items)
      }
  }

  public func rootSend(item: LinkItem<ItemValue>) {
    rootController?.viewControllers.compactMap { $0 as? MatchPathUsable }
      .filter { item.pathList.contains($0.matchPath) }
      .forEach {
        guard case .dictionary(let subscriber) = $0.eventSubscriber
        else { return }
        DispatchQueue.main.async {
          subscriber.receive(item: item.items)
        }
      }
  }

  public func mainSend(item: ItemValue) {
    guard let owner else { return }
    guard case .dictionary(let subscriber) = owner else { return }
    DispatchQueue.main.async {
      subscriber.receive(item: item)
    }
  }

  public func allSend(item: ItemValue) {
    activeController?.viewControllers.compactMap { $0 as? MatchPathUsable }
      .forEach {
        guard case .dictionary(let subscriber) = $0.eventSubscriber
        else { return }
        DispatchQueue.main.async {
          subscriber.receive(item: item)
        }
      }
  }

  public func allRootSend(item: ItemValue) {
    rootController?.viewControllers.compactMap { $0 as? MatchPathUsable }
      .forEach {
        guard case .dictionary(let subscriber) = $0.eventSubscriber
        else { return }
        DispatchQueue.main.async {
          subscriber.receive(item: item)
        }
      }
  }
}

// MARK: SingleLinkNavigator.Coordinate

extension SingleLinkNavigator {
  fileprivate class Coordinate: NSObject, UIAdaptivePresentationControllerDelegate {

    // MARK: Lifecycle

    init(sheetDidDismiss: @escaping () -> Void) {
      self.sheetDidDismiss = sheetDidDismiss
    }

    // MARK: Internal

    var sheetDidDismiss: () -> Void

    func presentationControllerDidDismiss(_: UIPresentationController) {
      sheetDidDismiss()
    }
  }
}

extension UINavigationController {
  fileprivate func currentItemList() -> [String] {
    viewControllers.compactMap { $0 as? MatchPathUsable }.map(\.matchPath)
  }

  fileprivate func merge(new: [UIViewController], isAnimated: Bool) {
    setViewControllers(viewControllers + new, animated: isAnimated)
  }

  fileprivate func back(isAnimated: Bool) {
    popViewController(animated: isAnimated)
  }

  fileprivate func clear(isAnimated: Bool) {
    setViewControllers([], animated: isAnimated)
  }

  fileprivate func push(viewController: UIViewController?, isAnimated: Bool) {
    guard let viewController else { return }
    pushViewController(viewController, animated: isAnimated)
  }

  fileprivate func replace(viewController: [UIViewController], isAnimated: Bool) {
    setViewControllers(viewController, animated: isAnimated)
  }

  fileprivate func popTo(viewController: UIViewController?, isAnimated: Bool) {
    guard let viewController else { return }
    popToViewController(viewController, animated: isAnimated)
  }

  fileprivate func dropLast() -> [UIViewController] {
    Array(viewControllers.dropLast())
  }
}
