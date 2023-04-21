import UIKit

public protocol LinkNavigatorType {

  /// Returns an array of ``RouteBuilder/matchPath`` of the current navigation stack.
  ///
  /// The ``currentPaths`` will return current navigation stack
  /// an array of  ``RouteBuilder/matchPath``, which is `String` type.
  ///
  /// Let's Suppose that your current stack is `Home/Page1/Page2`.
  ///
  /// ```swift
  /// var currentStack = navigator.currentPaths
  /// print(currentStack) // Prints "["home", "page1", "page2"]"
  /// ```
  ///
  /// - Note: if the modal is active, ``currentPaths`` will return
  ///   the `subNavigationController`'s current navigation stack,
  ///   even when you call ``currentPaths`` on root page.
  ///
  /// - Returns: Current navigation stack as an array.
  var currentPaths: [String] { get }

  /// Returns an array of ``RouteBuilder/matchPath`` of the `rootNavigationController`'s current navigation stack.
  ///
  /// ```swift
  /// // current `root` navigation stack == ["dashboard", "signIn"]
  /// // current `sub` navigation stack == ["signUp"]
  ///
  /// var rootStack = navigator.rootCurrentPaths
  /// print(rootStack) // Prints "["dashboard", "signIn"]"
  /// ```
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
  ///       WrappingController(matchPath: matchPath) {
  ///         Page4View(
  ///           store: .init(
  ///             initialState: Page4.State(message: items["page4-message"] ?? ""), // catches here.
  ///             reducer: Page4()))
  ///       }
  ///     }
  ///   }
  /// }
  /// ```
  ///
  /// - Parameters:
  ///   - paths: An array of ``RouteBuilder/matchPath`` for some specific pages.
  ///   - items: A dictionary of `String` type key-value pairs.
  ///   - isAnimated: makes the transition to be animated.
  func next(paths: [String], items: [String: String], isAnimated: Bool)

  /// Pushes one or many pages on the `rootNavigationController`'s current
  /// navigation stack, especially when the modal is active.
  ///
  /// - Note: If the modal is inactive, this method does same thing as ``next(paths:items:isAnimated:)``.
  ///
  /// - Parameters:
  ///   - paths: An array of ``RouteBuilder/matchPath`` for some specific pages.
  ///   - items: A dictionary of `String` type key-value pairs.
  ///   - isAnimated: makes the transition to be animated.
  func rootNext(paths: [String], items: [String: String], isAnimated: Bool)

  /// Presents a sheet that has its own navigation stack.
  ///
  /// - Note: If there's an active modal in `rootNavigationController`, then
  ///   ``sheet(paths:items:isAnimated:)`` will dismiss that modal and present a new one.
  ///
  /// - Parameters:
  ///   - paths: An array of ``RouteBuilder/matchPath`` for some specific pages.
  ///   - items: A dictionary of `String` type key-value pairs.
  ///   - isAnimated: makes the transition to be animated.
  func sheet(paths: [String], items: [String: String], isAnimated: Bool)

  /// Presents a full screen sheet that has its own navigation stack.
  ///
  /// - Note: If there's an active modal in `rootNavigationController`, then
  ///   ``fullSheet(paths:items:isAnimated:)`` will dismiss that modal and present a new one.
  ///
  /// - Parameters:
  ///   - paths: An array of ``RouteBuilder/matchPath`` for some specific pages.
  ///   - items: A dictionary of `String` type key-value pairs.
  ///   - isAnimated: makes the transition to be animated.
  ///   - prefersLargeTitles:
  ///         The SubNavigationViewController has a Boolean value that determines whether to display the title in a large format.
  ///         ``If the value is null or .none, the previously set value will be maintained.``
  ///         You can set it to true to use a large title in the modal or control it dynamically.
  ///
  func fullSheet(paths: [String], items: [String: String], isAnimated: Bool, prefersLargeTitles: Bool?)

  /// Presents a custom sheet that has its own navigation stack.
  ///
  /// You can choose modal presentation styles for iPhone and iPad respectively.
  ///
  /// ```swift
  /// navigator.customSheet(
  ///   paths: ["signIn"],
  ///   items: [:],
  ///   isAnimated: true,
  ///   iPhonePresentationStyle: .fullScreen,
  ///   iPadPresentationStyle: .automatic,
  ///   prefersLargeTitles: .none)
  /// ```
  ///
  /// - Note: If there's an active modal in `rootNavigationController`, then
  ///   ``customSheet(paths:items:isAnimated:iPhonePresentationStyle:iPadPresentationStyle:)``
  ///   will dismiss that modal and present a new one.
  ///
  /// - Parameters:
  ///   - paths: An array of ``RouteBuilder/matchPath`` for some specific pages.
  ///   - items: A dictionary of `String` type key-value pairs.
  ///   - isAnimated: makes the transition to be animated.
  ///   - prefersLargeTitles:
  ///         The SubNavigationViewController has a Boolean value that determines whether to display the title in a large format.
  ///         ``If the value is null or .none, the previously set value will be maintained.``
  ///         You can set it to true to use a large title in the modal or control it dynamically.
  func customSheet(
    paths: [String],
    items: [String: String],
    isAnimated: Bool,
    iPhonePresentationStyle: UIModalPresentationStyle,
    iPadPresentationStyle: UIModalPresentationStyle,
    prefersLargeTitles: Bool?)

  /// Replaces current navigation stack managed by `rootNavigationController` with the new one.
  ///
  /// Let's suppose that you only know the `dashboard` page is in the current navigation stack.
  /// You want to keep the pages up to the `dashboard` and append some new pages after that.
  /// In order to figure out unknown pages up to a specific page, you need to use ``range(path:)`` method.
  ///
  /// ```swift
  /// // current navigation stack == [..., "dashboard", ...]
  /// // you want to make a new stack like this, [..., "dashboard", "step1", "step2"].
  ///
  /// var new = navigator.range(path: "dashboard") + ["step1", "step2"]
  /// navigator.replace(paths: new, items: [:], isAnimated: true)
  /// ```
  ///
  /// - Parameters:
  ///   - paths: An array of ``RouteBuilder/matchPath`` for some specific pages.
  ///   - items: A dictionary of `String` type key-value pairs.
  ///   - isAnimated: makes the transition to be animated.
  func replace(paths: [String], items: [String: String], isAnimated: Bool)

  /// Pushes or Rewinds a specific page.
  ///
  /// If the page you want is already contained in the current navigation stack,
  /// `navigator` rewinds to that page.
  /// Else If the page is *not* contained in the stack,
  /// `navigator` pushes that page same as ``next(paths:items:isAnimated:)`` method.
  ///
  /// ```swift
  /// // Rewinding
  /// // current navigation stack == [..., "dashboard", ..., "setting"]
  ///
  /// navigator.backOrNext(path: "dashboard", items: [:], isAnimated: true)
  /// // then, you will have this stack, [..., "dashboard"]
  ///
  /// // Pushing
  /// // current navigation stack == [..., "setting"]
  ///
  /// navigator.backOrNext(path: "alarm", items: [:], isAnimated: true)
  /// // then, you will have this stack, [..., "setting", "alarm"]
  /// ```
  ///
  /// - Parameters:
  ///   - path: A string of ``RouteBuilder/matchPath`` for a specific page.
  ///   - items: A dictionary of `String` type key-value pairs.
  ///   - isAnimated: makes the transition to be animated.
  func backOrNext(path: String, items: [String: String], isAnimated: Bool)

  /// Pushes or Rewinds a specific page on the `rootNavigationController`'s current
  /// navigation stack, especially when the modal is active.
  ///
  /// If the page you want is already contained in the root navigation stack,
  /// `navigator` rewinds to that page.
  /// Else If the page is *not* contained in the stack,
  /// `navigator` pushes that page same as ``rootNext(paths:items:isAnimated:)`` method.
  ///
  /// Let's suppose that you will select a specific clothing on the modal page.
  /// When you tap some button, `clothingDetail` page will be presented behind the modal
  /// so that you can see the `clothingDetail` page after dismissing the modal.
  ///
  /// ```swift
  /// // current `root` navigation stack == [..., "dashboard"]
  /// // current `sub` navigation stack == ["selectClothing"]
  ///
  /// navigator.rootBackOrNext(
  ///   path: "clothingDetail",
  ///   items: ["clothingID": "123"],
  ///   isAnimated: false)
  /// // then, current `root` stack == [..., "dashboard", "clothingDetail"]
  /// ```
  ///
  /// - Note: If the modal is inactive, this method does same thing as ``backOrNext(path:items:isAnimated:)``.
  ///
  /// - Parameters:
  ///   - path: A string of ``RouteBuilder/matchPath`` for a specific page.
  ///   - items: A dictionary of `String` type key-value pairs.
  ///   - isAnimated: makes the transition to be animated.
  func rootBackOrNext(path: String, items: [String: String], isAnimated: Bool)

  /// Goes back to previous page.
  ///
  /// If you are on the modal that has only one page,
  /// ``back(isAnimated:)`` will dismiss the modal.
  ///
  /// - Parameters:
  ///   - isAnimated: makes the transition to be animated.
  func back(isAnimated: Bool)

  /// Removes one or many pages.
  ///
  /// ```swift
  /// // current navigation stack == ["signUpStep1", "signUpStep2", "dashboard"]
  ///
  /// navigator.remove(paths: ["signUpStep1", "signUpStep2"])
  /// // then, you will have this stack, ["dashboard"]
  /// ```
  ///
  /// - Note: Do not use ``remove(paths:)`` for popping the last page.
  ///   Use ``back(isAnimated:)`` method instead.
  ///
  /// - Parameters:
  ///   - paths: An array of ``RouteBuilder/matchPath`` for some specific pages.
  func remove(paths: [String])

  /// Removes one or many pages on the `rootNavigationController`'s current
  /// navigation stack, especially when the modal is active.
  ///
  /// Let's suppose that you will sign up on the modal page.
  /// When you finish, `signIn` page behind the modal will be removed
  /// so that you can see the `dashboard` page after dismissing the modal.
  ///
  /// ```swift
  /// // current `root` navigation stack == ["dashboard", "signIn"]
  /// // current `sub` navigation stack == ["signUp"]
  ///
  /// navigator.rootRemove(paths: ["signIn"])
  /// // then, current `root` stack == ["dashboard"]
  /// ```
  ///
  /// - Note: If the modal is inactive, this method does same thing as ``remove(paths:)``.
  ///
  /// - Parameters:
  ///   - paths: An array of ``RouteBuilder/matchPath`` for some specific pages.
  func rootRemove(paths: [String])

  /// Rewinds a specific page.
  ///
  /// If you have a duplicated pages in the current navigation stack,
  /// `navigator` rewinds to the last page of stack.
  ///
  /// ```swift
  /// // current navigation stack == ["pageA", "pageA", "pageB", "pageC"]
  ///
  /// navigator.backToLast(path: "pageA", isAnimated: true)
  /// // then, you will have this stack, ["pageA", "pageA"]
  /// ```
  ///
  /// - Parameters:
  ///   - path: A string of ``RouteBuilder/matchPath`` for a specific page.
  ///   - isAnimated: makes the transition to be animated.
  func backToLast(path: String, isAnimated: Bool)

  /// Rewinds a specific page on the `rootNavigationController`'s current
  /// navigation stack, especially when the modal is active.
  ///
  /// If you have a duplicated pages in the root navigation stack,
  /// `navigator` rewinds to the last page of stack.
  ///
  /// ```swift
  /// // current `root` navigation stack == ["pageA", "pageA", "pageB", "pageC"]
  /// // current `sub` navigation stack == ["pageD"]
  ///
  /// navigator.rootBackToLast(path: "pageA", isAnimated: true)
  /// // then, current `root` stack == ["pageA", "pageA"]
  /// ```
  /// - Note: If the modal is inactive, this method does same thing as ``backToLast(path:isAnimated:)``.
  ///
  /// - Parameters:
  ///   - path: A string of ``RouteBuilder/matchPath`` for a specific page.
  ///   - isAnimated: makes the transition to be animated.
  func rootBackToLast(path: String, isAnimated: Bool)

  /// Dismisses the modal and calls completion closure.
  ///
  /// - Note: If the modal is inactive, this method will be ignored.
  ///
  /// - Parameters:
  ///   - isAnimated: makes the transition to be animated.
  ///   - completeAction: The closure to execute after the modal is dismissed.
  ///     This closure has no return value and takes no parameters.
  func close(isAnimated: Bool, completeAction: @escaping () -> Void)

  /// Returns an array of ``RouteBuilder/matchPath`` up to a specific page from the current navigation stack.
  ///
  /// Let's suppose that you want to know pages up to the specific page which is `dashboard`.
  ///
  /// ```swift
  /// // current navigation stack == ["page1", "page2", "dashboard", ...]
  ///
  /// var stackUpToDashboard = navigator.range(path: "dashboard")
  /// print(stackUpToDashboard) // Prints "["page1", "page2", "dashboard"]"
  /// ```
  ///
  /// - Note: If the argument of `path` is not contained in the current navigation stack,
  ///   this method does same thing as ``currentPaths``.
  ///
  /// - Parameters:
  ///   - path: A string of ``RouteBuilder/matchPath`` for a specific page.
  ///
  /// - Returns: An array of  ``RouteBuilder/matchPath`` up to a specific page from the current navigation stack.
  func range(path: String) -> [String]

  /// Reloads the last page of the `rootNavigationController`'s current navigation stack.
  ///
  /// Let's suppose that you will sign in on the modal page.
  /// When you finish, the `dashboard` page behind the modal should be reloaded
  /// so that you can see the personalized `dashboard` page after dismissing the modal.
  ///
  /// ```swift
  /// // current `root` navigation stack == ["dashboard"]
  /// // current `sub` navigation stack == ["signIn"]
  ///
  /// case .onTapSignIn:
  ///   // some signing in process...
  ///   navigator.rootReloadLast(items: [:], isAnimated: false)
  ///   navigator.close(isAnimated: true, completeAction: { })
  /// ```
  ///
  /// - Parameters:
  ///   - items: A dictionary of `String` type key-value pairs.
  ///   - isAnimated: makes the transition to be animated.
  func rootReloadLast(items: [String: String], isAnimated: Bool)

  /// Presents a system Alert.
  ///
  /// If the `target` parameter is set to `default`, an Alert is shown regardless of whether the modal is active.
  /// Also, you can opt-in on which view controller to show an Alert. (`root` or `sub`)
  ///
  /// ```swift
  /// case .onTapAlert:
  ///   let alertModel = Alert(
  ///     title: "Title",
  ///     message: "message",
  ///     buttons: [.init(title: "OK", style: .default, action: { print("OK tapped") })],
  ///     flagType: .default)
  ///
  ///   navigator.alert(target: .default, model: alertModel)
  /// ```
  ///
  /// - Parameters:
  ///   - target: The view controller to show an Alert.
  ///   - model: A custom type for building an Alert.
  func alert(target: NavigationTarget, model: Alert)
}

public final class LinkNavigator {
  let rootNavigationController: UINavigationController = .init()
  var subNavigationController: UINavigationController = .init()
  let dependency: DependencyType
  let builders: [RouteBuilder]

  private var coordinate: Coordinate = .init(sheetDidDismiss: { })

  public init(
    dependency: DependencyType,
    builders: [RouteBuilder])
  {
    self.dependency = dependency
    self.builders = builders

    self.coordinate = .init(sheetDidDismiss: { [weak self] in
      self?.subNavigationController.setViewControllers([], animated: false)
      self?.subNavigationController.presentationController?.delegate = .none
    })
  }
}

public enum NavigationTarget {
  case `default`
  case root
  case sub
}

extension LinkNavigator {

  public func launch(paths: [String], items: [String: String], prefersLargeTitles: Bool = false) -> RootNavigator {
    let viewControllers = paths.compactMap { path in
      builders.first(where: { $0.matchPath == path })?.build(self, items, dependency)
    }
    rootNavigationController.setViewControllers(viewControllers, animated: false)
    rootNavigationController.navigationBar.prefersLargeTitles = prefersLargeTitles

    return RootNavigator(viewController: rootNavigationController)
  }
}

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

  public func sheet(paths:[String], items: [String: String], isAnimated: Bool) {
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
    let start = currentPaths.startIndex
    let end = currentPaths.enumerated().first(where: { $0.element == path})?.offset ?? currentPaths.endIndex - 1
    return Array(currentPaths[start...max(start, end)])
  }

  public func rootReloadLast(items: [String : String], isAnimated: Bool) {
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

fileprivate extension LinkNavigator {
  var isSubNavigationControllerPresented: Bool {
    rootNavigationController.presentedViewController != .none
  }

  var currentActivityNavigationController: UINavigationController {
    isSubNavigationControllerPresented ? subNavigationController : rootNavigationController
  }

  func isCurrentContain(path: String) -> Bool {
    currentActivityNavigationController
      .viewControllers
      .compactMap { $0 as? MatchPathUsable }
      .first(where: { $0.matchPath == path }) != nil
  }

  func isCurrentContainRootViewController(path: String) -> Bool {
    rootNavigationController
      .viewControllers
      .compactMap { $0 as? MatchPathUsable }
      .first(where: { $0.matchPath == path }) != nil
  }

  func findFirstViewController(path: String) -> UIViewController? {
    currentActivityNavigationController
      .viewControllers
      .compactMap { $0 as? MatchPathUsable & UIViewController }
      .first(where: { $0.matchPath == path })
  }

  func findLastViewController(path: String) -> UIViewController? {
    currentActivityNavigationController
      .viewControllers
      .compactMap { $0 as? MatchPathUsable & UIViewController }
      .last(where: { $0.matchPath == path })
  }

  func findFirstViewControllerRootView(path: String) -> UIViewController? {
    rootNavigationController
      .viewControllers
      .compactMap { $0 as? MatchPathUsable & UIViewController }
      .first(where: { $0.matchPath == path })
  }

  func findLastViewControllerRootView(path: String) -> UIViewController? {
    rootNavigationController
      .viewControllers
      .compactMap { $0 as? MatchPathUsable & UIViewController }
      .last(where: { $0.matchPath == path })
  }
}

extension LinkNavigator {
  fileprivate class Coordinate: NSObject, UIAdaptivePresentationControllerDelegate {
    init(sheetDidDismiss: @escaping () -> Void) {
      self.sheetDidDismiss = sheetDidDismiss
    }

    var sheetDidDismiss: () -> Void

    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
      sheetDidDismiss()
    }
  }
}
