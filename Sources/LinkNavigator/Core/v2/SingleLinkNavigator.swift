import UIKit

// MARK: - SingleLinkNavigator

public final class SingleLinkNavigator {

  // MARK: Lifecycle

  public init(
    rootNavigator: Navigator,
    routeBuilderItemList: [RouteBuilderOf<SingleLinkNavigator>],
    dependency: DependencyType,
    subNavigator: Navigator? = nil)
  {
    self.rootNavigator = rootNavigator
    self.routeBuilderItemList = routeBuilderItemList
    self.dependency = dependency
    self.subNavigator = subNavigator
  }

  // MARK: Public

  public let rootNavigator: Navigator
  public let routeBuilderItemList: [RouteBuilderOf<SingleLinkNavigator>]
  public let dependency: DependencyType

  public var subNavigator: Navigator?

  // MARK: Private

  private var coordinate: Coordinate = .init(sheetDidDismiss: { })

}

extension SingleLinkNavigator {

  public func launch() -> BaseNavigator {
    rootNavigator.replace(
      rootNavigator: self,
      item: rootNavigator.initialLinkItem,
      isAnimated: false,
      routeBuilderList: routeBuilderItemList,
      dependency: dependency)

    return .init(viewController: rootNavigator.controller)
  }
}

// MARK: LinkNavigatorProtocol

extension SingleLinkNavigator: LinkNavigatorProtocol {
  public var activeNavigator: Navigator? {
    isSubNavigatorActive ? subNavigator : rootNavigator
  }

  public var currentPaths: [String] {
    isSubNavigatorActive ? subNavigatorCurrentPaths : rootCurrentPaths
  }

  public var rootCurrentPaths: [String] {
    rootNavigator.viewControllers.map(\.matchPath)
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
    rootNavigator.push(
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
    rootNavigator.controller.dismiss(animated: isAnimated) { [weak self] in
      guard let self else { return }
      subNavigator?.reset(isAnimated: isAnimated)
      subNavigator?.controller.presentationController?.delegate = .none
    }
    rootNavigator.replace(
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
      routeBuilderList: routeBuilderItemList,
      dependency: dependency)
  }

  public func rootBackOrNext(linkItem: LinkItem, isAnimated: Bool) {
    guard let path = linkItem.pathList.first else { return }
    guard let pick = rootNavigator.viewControllers.first(where: { $0.matchPath == path }) else {
      rootNavigator.push(
        rootNavigator: self,
        item: .init(path: path, items: linkItem.items),
        isAnimated: isAnimated,
        routeBuilderList: routeBuilderItemList,
        dependency: dependency)
      return
    }
    rootNavigator.controller.popToViewController(pick, animated: isAnimated)
  }

  public func back(isAnimated: Bool) {
    isSubNavigatorActive
      ? sheetBack(isAnimated: isAnimated)
      : rootNavigator.back(isAnimated: isAnimated)
  }

  public func remove(pathList: [String]) {
    activeNavigator?.remove(item: .init(pathList: pathList))
  }

  public func rootRemove(pathList: [String]) {
    rootNavigator.remove(item: .init(pathList: pathList))
  }

  public func backToLast(path: String, isAnimated: Bool) {
    activeNavigator?.backToLast(item: .init(path: path), isAnimated: isAnimated)
  }

  public func rootBackToLast(path: String, isAnimated: Bool) {
    rootNavigator.backToLast(item: .init(path: path), isAnimated: isAnimated)
  }

  public func close(isAnimated: Bool, completeAction: @escaping () -> Void) {
    guard activeNavigator == subNavigator else { return }
    rootNavigator.controller.dismiss(animated: isAnimated) { [weak self] in
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

  public func rootReloadLast(items: String, isAnimated: Bool) {
    guard let lastPath = rootCurrentPaths.last else { return }
    guard let new = routeBuilderItemList.first(where: { $0.matchPath == lastPath })?.routeBuild(self, items, dependency)
    else { return }

    let newList = Array(rootNavigator.controller.viewControllers.dropLast()) + [new]
    rootNavigator.controller.setViewControllers(newList, animated: isAnimated)
  }

  public func alert(target: NavigationTarget, model: Alert) {
    switch target {
    case .default:
      alert(target: isSubNavigatorActive ? .sub : .root, model: model)
    case .root:
      rootNavigator.controller.present(model.build(), animated: true)
    case .sub:
      subNavigator?.controller.present(model.build(), animated: true)
    }
  }
}

/// MARK: - Main
extension SingleLinkNavigator {
  public var isSubNavigatorActive: Bool {
    rootNavigator.controller.presentedViewController != .none
  }
}

/// MARK: - Sub
extension SingleLinkNavigator {

  // MARK: Public

  public func sheetOpen(
    item: LinkItem,
    isAnimated: Bool,
    prefersLargeTitles: Bool? = .none,
    presentWillAction: @escaping (UINavigationController) -> Void = { _ in },
    presentDidAction: @escaping (UINavigationController) -> Void = { _ in })
  {
    rootNavigator.controller.dismiss(animated: true)

    let new = Navigator(initialLinkItem: item)
    if let prefersLargeTitles { new.controller.navigationBar.prefersLargeTitles = prefersLargeTitles }
    presentWillAction(new.controller)

    new.replace(
      rootNavigator: self,
      item: item,
      isAnimated: false,
      routeBuilderList: routeBuilderItemList,
      dependency: dependency)
    rootNavigator.controller.present(new.controller, animated: isAnimated)
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
      rootNavigator.controller.dismiss(animated: true)
      self.subNavigator = .none
      return
    }
    subNavigator.back(isAnimated: isAnimated)
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

    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
      sheetDidDismiss()
    }
  }
}
