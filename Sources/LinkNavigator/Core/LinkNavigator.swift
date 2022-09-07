import UIKit

public protocol LinkNavigatorType {

  /// - Note: 현재의 Navigation 스택을 배열 형태로 반환합니다.
  var currentPaths: [String] { get }

  /// - Note: 특정 화면으로 이동합니다. 여러 개의 경로를 순서대로 입력해서 Navigation 스택을 쌓을 수 있습니다.
  func next(paths: [String], items: [String: String], isAnimated: Bool)

  /// - Note: Modal 이 올라와 있는 상황에서, 뒤에 있는 화면이 특정 화면으로 이동합니다.
  /// Modal 이 없는 상황에서는 next(path:items:isAnimated) 메서드와 동일하게 동작합니다.
  /// 여러 개의 경로를 순서대로 입력해서 Navigation 스택을 쌓을 수 있습니다.
  func rootNext(paths: [String], items: [String: String], isAnimated: Bool)

  /// - Note: 특정 화면을 Sheet Modal 형태로 올립니다.
  /// 여러 개의 경로를 순서대로 입력해서 Navigation 스택을 쌓을 수 있습니다.
  func sheet(paths: [String], items: [String: String], isAnimated: Bool)

  /// - Note: 특정 화면을 Full Sheet Modal 형태로 올립니다.
  /// 여러 개의 경로를 순서대로 입력해서 Navigation 스택을 쌓을 수 있습니다.
  func fullSheet(paths: [String], items: [String: String], isAnimated: Bool)

  /// - Note: 특정 화면을 Sheet Modal 형태로 올립니다.
  /// 여러 개의 경로를 순서대로 입력해서 Navigation 스택을 쌓을 수 있습니다.
  /// iOS 와 iPad 각각에서 어떤 Modal Presentation Style 을 사용할 것인지 분기처리할 수 있습니다.
  func customSheet(
    paths: [String],
    items: [String: String],
    isAnimated: Bool,
    iPhonePresentationStyle: UIModalPresentationStyle,
    iPadPresentationStyle: UIModalPresentationStyle)

  /// - Note: Navigation 스택을 교체합니다. 다른 맥락의 스택으로 이동하거나, 복잡하게 쌓인 스택을 청소할 때 사용합니다.
  func replace(paths: [String], items: [String: String], isAnimated: Bool)

  /// - Note: 하나의 특정 화면으로 이동합니다. 만약 그 경로가 이미 Navigation 스택에 있다면, 그 화면으로 돌아갑니다.
  /// 스택에 존재하지 않는 경로라면, 그 화면으로 이동하면서 Navigation 스택을 쌓습니다.
  func backOrNext(path: String, items: [String: String], isAnimated: Bool)

  /// - Note: Modal 이 올라와 있는 상황에서, 뒤에 있는 화면이 하나의 특정 화면으로 이동합니다.
  /// 만약 그 경로가 이미 Navigation 스택에 있다면, 그 화면으로 돌아갑니다.
  /// 스택에 존재하지 않는 경로라면, 그 화면으로 이동하면서 Navigation 스택을 쌓습니다.
  /// Modal 이 없는 상황에서는 backOrNext(path:items:isAnimated:) 메서드와 동일하게 동작합니다.
  func rootBackOrNext(path: String, items: [String: String], isAnimated: Bool)

  /// - Note: 직전 화면으로 돌아갑니다. Navigation, Modal 모두에서 사용 가능합니다.
  func back(isAnimated: Bool)

  /// - Note: Navigation 스택에서 특정 화면을 선택적으로 제거합니다.
  func remove(paths: [String])

  /// - Note: Modal 을 dismiss 하고 클로저를 실행합니다.
  /// 만약 Modal 이 올라와 있는 상황이 아니라면, 이 메서드는 무시됩니다.
  func close(completeAction: @escaping () -> Void)

  /// - Note: Navigation 스택에서 특정 화면까지의 경로를 배열 형태로 반환합니다.
  /// path 인자값으로 들어온 경로가 스택에 없는 경우, 현재의 Navigation 스택을 배열 형태로 반환합니다.
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
    rootNavigationController.dismiss(animated: true)

    subNavigationController.modalPresentationStyle = .automatic
    let new = paths.compactMap { path in
      builders.first(where: { $0.matchPath == path })?.build(self, items, dependency)
    }
    subNavigationController.setViewControllers(new, animated: false)
    rootNavigationController.present(subNavigationController, animated: isAnimated)
  }

  public func fullSheet(paths: [String], items: [String: String], isAnimated: Bool) {
    rootNavigationController.dismiss(animated: true)

    subNavigationController.modalPresentationStyle = .fullScreen
    let new = paths.compactMap { path in
      builders.first(where: { $0.matchPath == path })?.build(self, items, dependency)
    }
    subNavigationController.setViewControllers(new, animated: false)
    rootNavigationController.present(subNavigationController, animated: isAnimated)
  }

  public func customSheet(
    paths: [String],
    items: [String: String],
    isAnimated: Bool,
    iPhonePresentationStyle: UIModalPresentationStyle,
    iPadPresentationStyle: UIModalPresentationStyle)
  {
    rootNavigationController.dismiss(animated: true)

    subNavigationController.modalPresentationStyle = UIDevice.current.userInterfaceIdiom == .phone
      ? iPhonePresentationStyle
      : iPadPresentationStyle

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

  public func rootBackOrNext(path: String, items: [String: String], isAnimated: Bool) {
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
