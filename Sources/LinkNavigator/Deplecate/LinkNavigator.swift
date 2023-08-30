import UIKit

// MARK: - LinkNavigator

public final class LinkNavigator {

  // MARK: Lifecycle

  public init(
    dependency: DependencyType,
    builders: [RouteBuilder])
  {
    self.dependency = dependency
    self.builders = builders

    coordinate = .init(sheetDidDismiss: { [weak self] in
      self?.subNavigationController.setViewControllers([], animated: false)
      self?.subNavigationController.presentationController?.delegate = .none
    })
  }

  // MARK: Internal

  let rootNavigationController: UINavigationController = .init()
  var subNavigationController: UINavigationController = .init()
  let dependency: DependencyType
  let builders: [RouteBuilder]

  // MARK: Private

  private var coordinate: Coordinate = .init(sheetDidDismiss: { })

}

extension LinkNavigator {

  public func launch(paths: [String], items: [String: String], prefersLargeTitles: Bool = false) -> BaseNavigator {
    let viewControllers = paths.compactMap { path in
      builders.first(where: { $0.matchPath == path })?.build(self, items, dependency)
    }
    rootNavigationController.setViewControllers(viewControllers, animated: false)
    rootNavigationController.navigationBar.prefersLargeTitles = prefersLargeTitles

    return BaseNavigator(viewController: rootNavigationController)
  }
}

// MARK: - LinkNavigator + LinkNavigatorType

extension LinkNavigator: LinkNavigatorType {

  public var currentPaths: [String] {
    currentActivityNavigationController
      .viewControllers
      .compactMap { $0 as? MatchPathUsable }
      .map(\.matchPath)
  }

  public var rootCurrentPaths: [String] {
    rootNavigationController
      .viewControllers
      .compactMap { $0 as? MatchPathUsable }
      .map(\.matchPath)
  }

  public func next(paths: [String], items: [String: String], isAnimated: Bool) {
    let current = currentActivityNavigationController.viewControllers
    let new = paths.compactMap { path in
      builders.first(where: { $0.matchPath == path })?.build(self, items, dependency)
    }
    currentActivityNavigationController.setViewControllers(current + new, animated: isAnimated)
  }

  public func rootNext(paths: [String], items: [String: String], isAnimated: Bool) {
    let current = rootNavigationController.viewControllers
    let new = paths.compactMap { path in
      builders.first(where: { $0.matchPath == path })?.build(self, items, dependency)
    }
    rootNavigationController.setViewControllers(current + new, animated: isAnimated)
  }

  public func sheet(paths: [String], items: [String: String], isAnimated: Bool) {
    rootNavigationController.dismiss(animated: true)

    let newSubNavigationController = UINavigationController()
    newSubNavigationController.modalPresentationStyle = .automatic

    let new = paths.compactMap { path in
      builders.first(where: { $0.matchPath == path })?.build(self, items, dependency)
    }

    newSubNavigationController.setViewControllers(new, animated: false)

    newSubNavigationController.setViewControllers(new, animated: false)
    newSubNavigationController.presentationController?.delegate = coordinate
    rootNavigationController.present(newSubNavigationController, animated: isAnimated)

    subNavigationController = newSubNavigationController
  }

  public func fullSheet(paths: [String], items: [String: String], isAnimated: Bool, prefersLargeTitles: Bool?) {
    rootNavigationController.dismiss(animated: true)

    let newSubNavigationController = UINavigationController()
    newSubNavigationController.modalPresentationStyle = .fullScreen

    let new = paths.compactMap { path in
      builders.first(where: { $0.matchPath == path })?.build(self, items, dependency)
    }

    if let prefersLargeTitles {
      newSubNavigationController.navigationBar.prefersLargeTitles = prefersLargeTitles
    }

    newSubNavigationController.setViewControllers(new, animated: false)
    newSubNavigationController.presentationController?.delegate = coordinate

    rootNavigationController.present(newSubNavigationController, animated: isAnimated)

    subNavigationController = newSubNavigationController
  }

  public func customSheet(
    paths: [String],
    items: [String: String],
    isAnimated: Bool,
    iPhonePresentationStyle: UIModalPresentationStyle,
    iPadPresentationStyle: UIModalPresentationStyle,
    prefersLargeTitles: Bool?)
  {
    rootNavigationController.dismiss(animated: true)

    let newSubNavigationController = UINavigationController()

    newSubNavigationController.modalPresentationStyle = UIDevice.current.userInterfaceIdiom == .phone
      ? iPhonePresentationStyle
      : iPadPresentationStyle

    let new = paths.compactMap { path in
      builders.first(where: { $0.matchPath == path })?.build(self, items, dependency)
    }

    if let prefersLargeTitles = prefersLargeTitles {
      newSubNavigationController.navigationBar.prefersLargeTitles = prefersLargeTitles
    }

    newSubNavigationController.setViewControllers(new, animated: false)
    newSubNavigationController.presentationController?.delegate = coordinate
    rootNavigationController.present(newSubNavigationController, animated: isAnimated)

    subNavigationController = newSubNavigationController
  }

  public func replace(paths: [String], items: [String: String], isAnimated: Bool) {
    rootNavigationController.dismiss(animated: isAnimated, completion: {
      self.subNavigationController.setViewControllers([], animated: isAnimated)
      self.subNavigationController.presentationController?.delegate = .none
    })

    let new = paths.compactMap { path in
      builders.first(where: { $0.matchPath == path })?.build(self, items, dependency)
    }
    rootNavigationController.setViewControllers(new, animated: isAnimated)
  }

  public func backOrNext(path: String, items: [String: String], isAnimated: Bool) {
    if isCurrentContain(path: path) {
      guard let pick = findFirstViewController(path: path) else { return }
      currentActivityNavigationController.popToViewController(pick, animated: isAnimated)
      return
    }

    next(paths: [path], items: items, isAnimated: isAnimated)
  }

  public func rootBackOrNext(path: String, items: [String: String], isAnimated: Bool) {
    if isCurrentContainRootViewController(path: path) {
      guard let pick = findFirstViewControllerRootView(path: path) else { return }
      rootNavigationController.popToViewController(pick, animated: isAnimated)
      return
    }

    rootNext(paths: [path], items: items, isAnimated: isAnimated)
  }

  public func back(isAnimated: Bool) {
    guard currentActivityNavigationController.viewControllers.count < 2 else {
      currentActivityNavigationController.popViewController(animated: true)
      return
    }

    guard isSubNavigationControllerPresented else { return }
    currentActivityNavigationController.dismiss(animated: isAnimated, completion: {
      self.subNavigationController.setViewControllers([], animated: isAnimated)
    })
  }

  public func remove(paths: [String]) {
    let new = currentActivityNavigationController
      .viewControllers
      .compactMap{ $0 as? MatchPathUsable & UIViewController }
      .filter{ !paths.contains($0.matchPath) }

    guard new.count != currentActivityNavigationController.viewControllers.count else { return }
    currentActivityNavigationController.setViewControllers(new, animated: false)
  }

  public func rootRemove(paths: [String]) {
    let new = rootNavigationController
      .viewControllers
      .compactMap{ $0 as? MatchPathUsable & UIViewController }
      .filter{ !paths.contains($0.matchPath) }

    guard new.count != rootNavigationController.viewControllers.count else { return }
    rootNavigationController.setViewControllers(new, animated: false)
  }

  public func backToLast(path: String, isAnimated: Bool) {
    guard let pick = findLastViewController(path: path) else { return }
    currentActivityNavigationController.popToViewController(pick, animated: isAnimated)
  }

  public func rootBackToLast(path: String, isAnimated: Bool) {
    guard let pick = findLastViewControllerRootView(path: path) else { return }
    rootNavigationController.popToViewController(pick, animated: isAnimated)
  }

  public func close(isAnimated: Bool, completeAction: @escaping () -> Void) {
    guard isSubNavigationControllerPresented else { return }
    rootNavigationController.dismiss(animated: isAnimated, completion: {
      completeAction()
      self.subNavigationController.setViewControllers([], animated: isAnimated)
      self.subNavigationController.presentationController?.delegate = .none
    })
  }

  public func range(path: String) -> [String] {
    currentPaths.reduce([String]()) { current, next in
      guard current.contains(path) else { return current + [next] }
      return current
    }
  }

  public func rootReloadLast(items: [String: String], isAnimated: Bool) {
    guard let lastPath = rootCurrentPaths.last else { return }
    guard let new = builders.first(where: { $0.matchPath == lastPath })?.build(self, items, dependency) else { return }
    let joinedViewControllers = Array(rootNavigationController.viewControllers.dropLast()) + [new]
    rootNavigationController.setViewControllers(joinedViewControllers, animated: isAnimated)
  }

  public func alert(target: NavigationTarget, model: Alert) {
    switch target {
    case .default:
      alert(target: isSubNavigationControllerPresented ? .sub : .root, model: model)
    case .root:
      rootNavigationController.present(model.build(), animated: true, completion: .none)
    case .sub:
      subNavigationController.present(model.build(), animated: true, completion: .none)
    }
  }
}

extension LinkNavigator {
  fileprivate var isSubNavigationControllerPresented: Bool {
    rootNavigationController.presentedViewController != .none
  }

  fileprivate var currentActivityNavigationController: UINavigationController {
    isSubNavigationControllerPresented ? subNavigationController : rootNavigationController
  }

  fileprivate func isCurrentContain(path: String) -> Bool {
    currentActivityNavigationController
      .viewControllers
      .compactMap { $0 as? MatchPathUsable }
      .first(where: { $0.matchPath == path }) != nil
  }

  fileprivate func isCurrentContainRootViewController(path: String) -> Bool {
    rootNavigationController
      .viewControllers
      .compactMap { $0 as? MatchPathUsable }
      .first(where: { $0.matchPath == path }) != nil
  }

  fileprivate func findFirstViewController(path: String) -> UIViewController? {
    currentActivityNavigationController
      .viewControllers
      .compactMap { $0 as? MatchPathUsable & UIViewController }
      .first(where: { $0.matchPath == path })
  }

  fileprivate func findLastViewController(path: String) -> UIViewController? {
    currentActivityNavigationController
      .viewControllers
      .compactMap { $0 as? MatchPathUsable & UIViewController }
      .last(where: { $0.matchPath == path })
  }

  fileprivate func findFirstViewControllerRootView(path: String) -> UIViewController? {
    rootNavigationController
      .viewControllers
      .compactMap { $0 as? MatchPathUsable & UIViewController }
      .first(where: { $0.matchPath == path })
  }

  fileprivate func findLastViewControllerRootView(path: String) -> UIViewController? {
    rootNavigationController
      .viewControllers
      .compactMap { $0 as? MatchPathUsable & UIViewController }
      .last(where: { $0.matchPath == path })
  }
}

// MARK: - LinkNavigator.Coordinate

extension LinkNavigator {
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
