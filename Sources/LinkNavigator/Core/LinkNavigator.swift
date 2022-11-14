import UIKit

public protocol LinkNavigatorType {

  /// Returns the current navigation stack.
  ///
  /// - Note: if the modal is active, ``currentPaths`` will return
  ///   the `subNavigationController`'s current navigation stack,
  ///   even when you call ``currentPaths`` on root page.
  ///
  /// - Returns: Current navigation stack as an array.
  var currentPaths: [String] { get }

  /// Returns the `rootNavigationController`'s current navigation stack.
  ///
  /// - Returns: `rootNavigationController`'s current navigation stack as an array.
  var rootCurrentPaths: [String] { get }

  /// Pushes one or many pages.
  ///
  /// You can append one or many pages in sequence on the current navigation stack.
  /// If you want to pass some values to the next page, use `items` parameter.
  ///
  /// ```swift
  /// case .onTapNextWithMessage:
  ///   navigator.next(
  ///     paths: ["page4"],
  ///     items: ["page4-message": state.messageYouTyped], // passes values here.
  ///     isAnimated: true)
  ///
  /// // RouteBuilder catches `items`'s arguments using exact key.
  /// struct Page4RouteBuilder: RouteBuilder {
  ///   var matchPath: String { "page4" }
  ///
  ///   var build: (LinkNavigatorType, [String: String], DependencyType) -> UIViewController? {
  ///     { navigator, items, dep in
  ///       WrappingController(matchingKey: matchPath) {
  ///         AnyView(Page4View(
  ///           store: .init(
  ///             initialState: Page4.State(message: items["page4-message"] ?? ""), // catches here.
  ///             reducer: Page4())))
  ///       }
  ///     }
  ///   }
  /// }
  /// ```
  ///
  /// - Parameters:
  ///   - paths: An array of ``RouteBuilder/matchPath`` for the specific page.
  ///   - items: A dictionary of `String` type key-value pairs.
  ///   - isAnimated: makes the transition to be animated.
  func next(paths: [String], items: [String: String], isAnimated: Bool)

  /// Pushes one or many pages on the `rootNavigationController`'s current
  /// navigation stack, especially when the modal is active.
  ///
  /// - Note: If the modal is inactive, this method does same thing as ``next(paths:items:isAnimated:)``.
  ///
  /// - Parameters:
  ///   - paths: An array of ``RouteBuilder/matchPath`` for the specific page.
  ///   - items: A dictionary of `String` type key-value pairs.
  ///   - isAnimated: makes the transition to be animated.
  func rootNext(paths: [String], items: [String: String], isAnimated: Bool)

  /// 특정 화면을 Sheet Modal 형태로 올립니다.
  /// 여러 개의 경로를 순서대로 입력해서 Navigation 스택을 쌓을 수 있습니다.
  func sheet(paths: [String], items: [String: String], isAnimated: Bool)

  /// 특정 화면을 Full Sheet Modal 형태로 올립니다.
  /// 여러 개의 경로를 순서대로 입력해서 Navigation 스택을 쌓을 수 있습니다.
  func fullSheet(paths: [String], items: [String: String], isAnimated: Bool)

  /// 특정 화면을 Sheet Modal 형태로 올립니다.
  /// 여러 개의 경로를 순서대로 입력해서 Navigation 스택을 쌓을 수 있습니다.
  /// iOS 와 iPad 각각에서 어떤 Modal Presentation Style 을 사용할 것인지 분기처리할 수 있습니다.
  func customSheet(
    paths: [String],
    items: [String: String],
    isAnimated: Bool,
    iPhonePresentationStyle: UIModalPresentationStyle,
    iPadPresentationStyle: UIModalPresentationStyle)

  /// Navigation 스택을 교체합니다. 다른 맥락의 스택으로 이동하거나, 복잡하게 쌓인 스택을 청소할 때 사용합니다.
  func replace(paths: [String], items: [String: String], isAnimated: Bool)

  /// 하나의 특정 화면으로 이동합니다. 만약 그 경로가 이미 Navigation 스택에 있다면, 그 화면으로 돌아갑니다.
  /// 스택에 존재하지 않는 경로라면, 그 화면으로 이동하면서 Navigation 스택을 쌓습니다.
  func backOrNext(path: String, items: [String: String], isAnimated: Bool)

  /// Modal 이 올라와 있는 상황에서, 뒤에 있는 화면이 하나의 특정 화면으로 이동합니다.
  /// 만약 그 경로가 이미 Navigation 스택에 있다면, 그 화면으로 돌아갑니다.
  /// 스택에 존재하지 않는 경로라면, 그 화면으로 이동하면서 Navigation 스택을 쌓습니다.
  /// Modal 이 없는 상황에서는 backOrNext(path:items:isAnimated:) 메서드와 동일하게 동작합니다.
  func rootBackOrNext(path: String, items: [String: String], isAnimated: Bool)

  /// 직전 화면으로 돌아갑니다. Navigation, Modal 모두에서 사용 가능합니다.
  func back(isAnimated: Bool)

  /// Navigation 스택에서 특정 화면을 선택적으로 제거합니다.
  func remove(paths: [String])

  /// Modal 이 올라와 있는 상황에서, Root Navigation 스택에서 특정 화면을 선택적으로 제거합니다.
  func rootRemove(paths: [String])

  /// Modal 을 dismiss 하고 클로저를 실행합니다.
  /// 만약 Modal 이 올라와 있는 상황이 아니라면, 이 메서드는 무시됩니다.
  func close(isAnimated: Bool, completeAction: @escaping () -> Void)

  /// Navigation 스택에서 특정 화면까지의 경로를 배열 형태로 반환합니다.
  /// path 인자값으로 들어온 경로가 스택에 없는 경우, 현재의 Navigation 스택을 배열 형태로 반환합니다.
  func range(path: String) -> [String]

  /// Modal 이 올라와 있는 상황에서, 뒤에 있는 마지막 화면을 다시 로딩시킵니다.
  func rootReloadLast(isAnimated: Bool, items: [String: String])

  /// 시스템 Alert 를 보여줍니다.
  /// target 파라미터를 default 로 설정하면 Modal 이 올라와 있는 것과 무관하게 Alert 를 사용자에게 보여줍니다.
  /// 또는 Alert 를 보여줄 타겟 컨트롤러를 root, sub 중에서 선택할 수 있습니다.
  func alert(target: NavigationTarget, model: Alert)
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

public enum NavigationTarget {
  case `default`
  case root
  case sub
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

  public var rootCurrentPaths: [String] {
    rootNavigationController
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
    rootNavigationController.setViewControllers(new, animated: isAnimated)
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

  public func rootRemove(paths: [String]) {
    let new = rootNavigationController
      .viewControllers
      .compactMap{ $0 as? WrappingController }
      .filter{ !paths.contains($0.matchingKey) }

    guard new.count != rootNavigationController.viewControllers.count else { return }
    rootNavigationController.setViewControllers(new, animated: false)
  }

  public func close(isAnimated: Bool, completeAction: @escaping () -> Void) {
    guard isSubNavigationControllerPresented else { return }
    rootNavigationController.dismiss(animated: isAnimated, completion: {
      completeAction()
    })
  }

  public func range(path: String) -> [String] {
    let start = currentPaths.startIndex
    let end = currentPaths.enumerated().first(where: { $0.element == path})?.offset ?? currentPaths.endIndex - 1
    return Array(currentPaths[start...max(start, end)])
  }

  public func rootReloadLast(isAnimated: Bool, items: [String : String]) {
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
