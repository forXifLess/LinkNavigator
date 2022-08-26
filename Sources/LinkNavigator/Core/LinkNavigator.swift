import UIKit

public protocol LinkNavigatorType {
  var currentPaths: [String] { get }

  func next(paths: [String], items: [String: String], isAnimated: Bool)
  func rootNext(paths: [String], items: [String: String], isAnimated: Bool)
  func sheet(paths:[String], items: [String: String], isAnimated: Bool)
  func fullSheet(paths: [String], items: [String: String], isAnimated: Bool)
  func replace(paths: [String], items: [String: String], isAnimated: Bool)
  func backOrNext(path: String, items: [String: String], isAnimated: Bool)
  func rootBackOrNext(path: String, items: [String: String], isAnimated: Bool)
  func back(isAnimated: Bool)
  func remove(paths: [String])
  func close(completeAction: @escaping () -> Void)
  func range(path: String) -> [String]
}

public final class LinkNavigator {
	let rootNavigationController: UINavigationController
	let subNavigationController: UINavigationController
	let dependency: DependencyType
	let builders: [RouteBuilder]

	public init(
		rootNavigationController: UINavigationController = .init(),
		subNavigationController: UINavigationController = .init(),
		dependency: DependencyType,
    builders: [RouteBuilder]) {
		self.rootNavigationController = rootNavigationController
		self.subNavigationController = subNavigationController
		self.dependency = dependency
		self.builders = builders
	}
}

extension LinkNavigator {
  public func launch(paths: [String], items: [String: String]) -> RootNavigator {
    let viewControllers = paths.compactMap { path in
      builders.first(where: { $0.matchPath == path })?.build(self, items, dependency)
    }
    rootNavigationController.setViewControllers(viewControllers, animated: false)

    return RootNavigator(viewController: rootNavigationController)
  }
}

extension LinkNavigator: LinkNavigatorType {

  public var currentPaths: [String] {
    currentActivityNavigationController
      .viewControllers
      .compactMap { $0 as? WrappingController }
      .map(\.matchingKey)
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

  public func sheet(paths:[String], items: [String: String], isAnimated: Bool) {
    rootNavigationController.dismiss(animated: false)

    subNavigationController.modalPresentationStyle = .automatic
    let new = paths.compactMap { path in
      builders.first(where: { $0.matchPath == path })?.build(self, items, dependency)
    }
    subNavigationController.setViewControllers(new, animated: false)
    rootNavigationController.present(subNavigationController, animated: isAnimated)
  }

  public func fullSheet(paths: [String], items: [String: String], isAnimated: Bool) {
    rootNavigationController.dismiss(animated: false)

    subNavigationController.modalPresentationStyle = .fullScreen
    let new = paths.compactMap { path in
      builders.first(where: { $0.matchPath == path })?.build(self, items, dependency)
    }
    subNavigationController.setViewControllers(new, animated: false)
    rootNavigationController.present(subNavigationController, animated: isAnimated)
  }

  public func replace(paths: [String], items: [String: String], isAnimated: Bool) {
    subNavigationController.dismiss(animated: isAnimated)
    let new = paths.compactMap { path in
      builders.first(where: { $0.matchPath == path })?.build(self, items, dependency)
    }
    currentActivityNavigationController.setViewControllers(new, animated: isAnimated)
  }

  public func backOrNext(path: String, items: [String: String], isAnimated: Bool) {
    if isCurrentContain(path: path) {
      guard let pick = findViewController(path: path) else { return }
      currentActivityNavigationController.popToViewController(pick, animated: isAnimated)
      return
    }

    next(paths: [path], items: items, isAnimated: isAnimated)
  }

  public func rootBackOrNext(path: String, items: [String : String], isAnimated: Bool) {
    if isCurrentContainRootViewController(path: path) {
      guard let pick = findViewControllerRootView(path: path) else { return }
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
    currentActivityNavigationController.dismiss(animated: isAnimated)
  }

  public func remove(paths: [String]) {
    let new = currentActivityNavigationController
      .viewControllers
      .compactMap{ $0 as? WrappingController }
      .filter{ !paths.contains($0.matchingKey) }

    guard new.count != currentActivityNavigationController.viewControllers.count else { return }
    currentActivityNavigationController.setViewControllers(new, animated: false)
  }

  public func close(completeAction: @escaping () -> Void) {
    guard isSubNavigationControllerPresented else { return }
    rootNavigationController.dismiss(animated: true, completion: {
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.23) {
        completeAction()
      }
    })
  }

  public func range(path: String) -> [String] {
    let start = currentPaths.startIndex
    let end = currentPaths.enumerated().first(where: { $0.element == path})?.offset ?? currentPaths.endIndex - 1
    return Array(currentPaths[start...max(start, end)])
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
      .compactMap { $0 as? WrappingController }
      .first(where: { $0.matchingKey == path }) != .none
  }

  fileprivate func isCurrentContainRootViewController(path: String) -> Bool {
    rootNavigationController
      .viewControllers
      .compactMap { $0 as? WrappingController }
      .first(where: { $0.matchingKey == path }) != .none
  }

  fileprivate func findViewController(path: String) -> UIViewController? {
    currentActivityNavigationController
      .viewControllers
      .compactMap { $0 as? WrappingController }
      .first(where: { $0.matchingKey == path })
  }

  fileprivate func findViewControllerRootView(path: String) -> UIViewController? {
    rootNavigationController
      .viewControllers
      .compactMap { $0 as? WrappingController }
      .first(where: { $0.matchingKey == path })
  }
}
