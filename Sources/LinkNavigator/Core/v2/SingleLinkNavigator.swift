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

  // MARK: Private

  private var subNavigator: Navigator?
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

// MARK: LinkNavigatorType

extension SingleLinkNavigator: LinkNavigatorType {

  public var currentPaths: [String] {
    isSubNavigatorActive ? subNavigatorCurrentPaths : rootCurrentPaths
  }

  public var rootCurrentPaths: [String] {
    rootNavigator.viewControllers.map(\.matchPath)
  }

  public func next(paths: [String], items: [String: String], isAnimated: Bool) {
    activeNavigator.push(
      rootNavigator: self,
      item: .init(paths: paths, items: items),
      isAnimated: isAnimated,
      routeBuilderList: routeBuilderItemList,
      dependency: dependency)
  }

  public func rootNext(paths: [String], items: [String: String], isAnimated: Bool) {
    rootNavigator.push(
      rootNavigator: self,
      item: .init(paths: paths, items: items),
      isAnimated: isAnimated,
      routeBuilderList: routeBuilderItemList,
      dependency: dependency)
  }

  public func sheet(paths: [String], items: [String: String], isAnimated: Bool) {
    sheetOpen(item: .init(paths: paths, items: items), isAnimated: isAnimated)
  }

  public func fullSheet(paths: [String], items: [String: String], isAnimated: Bool, prefersLargeTitles: Bool?) {
    sheetOpen(
      item: .init(paths: paths, items: items),
      isAnimated: isAnimated,
      prefersLargeTitles: prefersLargeTitles,
      presentWillAction: {
        $0.modalPresentationStyle = .fullScreen
      },
      presentDidAction: {[weak self] in
        $0.presentationController?.delegate = self?.coordinate
      })
  }

  public func customSheet(paths: [String], items: [String: String], isAnimated: Bool, iPhonePresentationStyle: UIModalPresentationStyle, iPadPresentationStyle: UIModalPresentationStyle, prefersLargeTitles: Bool?) {
    sheetOpen(
      item: .init(paths: paths, items: items),
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

  public func replace(paths: [String], items: [String: String], isAnimated: Bool) {
    rootNavigator.controller.dismiss(animated: isAnimated) { [weak self] in
      guard let self else { return }
      subNavigator?.replace(rootNavigator: self, item: .init(paths: []), isAnimated: isAnimated, routeBuilderList: routeBuilderItemList, dependency: dependency)
      subNavigator?.controller.presentationController?.delegate = .none
    }
    activeNavigator.replace(
      rootNavigator: self,
      item: .init(paths: paths, items: items),
      isAnimated: isAnimated,
      routeBuilderList: routeBuilderItemList,
      dependency: dependency)
  }

  public func backOrNext(path: String, items: [String: String], isAnimated: Bool) {
    activeNavigator.backOrNext(
      rootNavigator: self,
      item: .init(paths: [path], items: items),
      isAnimated: isAnimated,
      routeBuilderList: routeBuilderItemList, dependency: dependency)
  }

  public func rootBackOrNext(path: String, items: [String: String], isAnimated: Bool) {
    guard let pick = rootNavigator.viewControllers.first(where: { $0.matchPath == path }) else {
      rootNavigator.push(
        rootNavigator: self,
        item: .init(paths: [ path ], items: items),
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

  public func remove(paths: [String]) {
    activeNavigator.remove(item: .init(paths: paths))
  }

  public func rootRemove(paths: [String]) {
    rootNavigator.remove(item: .init(paths: paths))
  }

  public func backToLast(path: String, isAnimated: Bool) {
    activeNavigator.backToLast(item: .init(paths: [ path ]), isAnimated: isAnimated)
  }

  public func rootBackToLast(path: String, isAnimated: Bool) {
    rootNavigator.backToLast(item: .init(paths: [ path ]), isAnimated: isAnimated)
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

  public func rootReloadLast(items: [String: String], isAnimated: Bool) {
    guard let lastPath = currentPaths.last else { return }
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
  private var isSubNavigatorActive: Bool {
    rootNavigator.controller.presentedViewController != .none
  }

  private var activeNavigator: Navigator {
    guard let subNavigator else { return rootNavigator }
    return isSubNavigatorActive ? subNavigator : rootNavigator
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
