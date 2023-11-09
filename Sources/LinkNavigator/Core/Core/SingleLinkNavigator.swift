import Foundation
import UIKit

/// The `SingleLinkNavigator` class manages the navigation within a single link setup.
/// It coordinates navigation functionalities like adding, removing, and navigating back to pages.
public final class SingleLinkNavigator {

  // MARK: - Lifecycle

  /// Initializes a new instance of `SingleLinkNavigator`.
  ///
  /// - Parameters:
  ///   - routeBuilderItemList: An array of `RouteBuilderOf` objects that are used as builders to create pages. These builders receive necessary parameters such as `ItemValue`, `RootNavigator`, and `Dependency` during the creation of pages.
  ///   - dependency: A necessary attribute for injecting MVI SideEffects which are used across the project, similar to a UseCase in clean architecture.
  public init(
    routeBuilderItemList: [RouteBuilderOf<SingleLinkNavigator>],
    dependency: DependencyType)
  {
    self.routeBuilderItemList = routeBuilderItemList
    self.dependency = dependency
  }

  // MARK: - Public Properties

  /// A collection of `RouteBuilderOf` objects utilized for the creation of new pages.
  public let routeBuilderItemList: [RouteBuilderOf<SingleLinkNavigator>]
  
  /// A requirement for injecting MVI SideEffects that are utilized across the entire project.
  public let dependency: DependencyType
  
  /// The central navigation controller that orchestrates the navigation flow.
  public weak var rootController: UINavigationController?
  
  /// A subscriber that holds the current link navigator.
  public var owner: LinkNavigatorItemSubscriberProtocol? = .none
  
  /// A navigation controller that oversees the display of subordinate navigation sequences.
  public var subController: UINavigationController?

  // MARK: - Private Properties

  private var coordinate: Coordinate = .init(sheetDidDismiss: { })

  private lazy var navigationBuilder: SingleNavigationBuilder<SingleLinkNavigator> = .init(
    rootNavigator: self,
    routeBuilderList: routeBuilderItemList,
    dependency: dependency)

}

extension SingleLinkNavigator {

  // MARK: - Public Methods

  /// Starts the navigation process with a specified item as the initial point.
  ///
  /// - Parameters:
  ///   - item: The initial link item used to commence the navigation process.
  ///   - prefersLargeTitles: A Boolean flag that indicates if the navigation bar prefers large titles. Defaults to `false`.
  /// 
  /// - Returns: A collection of `UIViewController` objects representing the initiated navigation flow.
  public func launch(item: LinkItem, prefersLargeTitles _: Bool = false) -> [UIViewController] {
    navigationBuilder.build(item: item)
  }

  // MARK: - Private Methods

  /// The operational navigation controller managing the current navigation flow.
  private var activeController: UINavigationController? {
    isSubNavigatorActive ? subController : rootController
  }
}

// MARK: - LinkNavigatorFindLocationUsable

extension SingleLinkNavigator: LinkNavigatorFindLocationUsable {

  /// Obtains the current paths within the navigation flow.
  ///
  /// - Returns: A collection of strings denoting the present paths.
  public func getCurrentPaths() -> [String] {
    isSubNavigatorActive ? subNavigatorCurrentPaths() : getRootCurrentPaths()
  }

  /// Retrieves the current paths from the root controller within the navigation sequence.
  ///
  /// - Returns: A collection of strings representing the current paths in the root navigation controller.
  public func getRootCurrentPaths() -> [String] {
    guard let controller = rootController else { return [] }
    return controller.currentItemList()
  }
}

extension SingleLinkNavigator {

  /// Initiates navigation to the next link item with the option of animation.
  /// 
  /// - Parameters:
  ///   - linkItem: An object representing the item to navigate to, it accepts either a `String` or a dictionary with `String` keys and values as `ItemValue`.
  ///   - isAnimated: A boolean to indicate if the navigation transition should be animated.
  private func _next(linkItem: LinkItem, isAnimated: Bool) {
    guard let activeController else { return }
    activeController.merge(
      new: navigationBuilder.build(item: linkItem),
      isAnimated: isAnimated)
  }

  /// Initiates navigation to the root link item with a merging transition, with an option for the transition to be animated.
  ///
  /// - Parameters:
  ///   - linkItem: An object representing the root item to navigate to, it can have either a `String` or a dictionary with `String` keys and values as `ItemValue`.
  ///   - isAnimated: A boolean to indicate if the navigation transition should be animated.
  private func _rootNext(linkItem: LinkItem, isAnimated: Bool) {
    guard let rootController else { return }

    rootController.merge(
      new: navigationBuilder.build(item: linkItem),
      isAnimated: isAnimated)
  }

  /// Opens a sheet with the specified link item and an option to animate the presentation.
  ///
  /// - Parameters:
  ///   - linkItem: An object representing the item to be presented in the sheet, can be a `String` or a dictionary with `String` keys and values as `ItemValue`.
  ///   - isAnimated: A boolean to indicate if the presentation should be animated.
  private func _sheet(linkItem: LinkItem, isAnimated: Bool) {
    sheetOpen(item: linkItem, isAnimated: isAnimated)
  }

  /// Opens a full-screen sheet with options for animation and large titles.
  ///
  /// - Parameters:
  ///   - linkItem: An object to be presented in the sheet, can be either a `String` or a dictionary with `String` keys and values as `ItemValue`.
  ///   - isAnimated: A boolean indicating whether the presentation should be animated.
  ///   - prefersLargeTitles: A boolean to indicate if large titles should be preferred in the navigation bar.
  private func _fullSheet(linkItem: LinkItem, isAnimated: Bool, prefersLargeTitles: Bool?) {
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

  /// Opens a custom sheet with specific presentation styles for iPhone and iPad, along with options for animation and large titles.
  ///
  /// - Parameters:
  ///   - linkItem: An object representing the item to be presented in the sheet, accepting a `String` or a dictionary with `String` keys and values as `ItemValue`.
  ///   - isAnimated: A boolean indicating whether the presentation should be animated.
  ///   - iPhonePresentationStyle: The presentation style for iPhone devices.
  ///   - iPadPresentationStyle: The presentation style for iPad devices.
  ///   - prefersLargeTitles: A boolean to specify if large titles should be preferred in the navigation bar.
  private func _customSheet(
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
      presentDidAction: { [weak self] in
        $0.presentationController?.delegate = self?.coordinate
      })
  }

  /// Replaces the current view controller with a new one built from the specified link item, with an option for the transition to be animated.
  ///
  /// - Parameters:
  ///   - linkItem: An object representing the item to build the new view controller from, accepting a `String` or a dictionary with `String` keys and values as `ItemValue`.
  ///   - isAnimated: A boolean indicating whether the transition should be animated.
  private func _replace(linkItem: LinkItem, isAnimated: Bool) {
    guard let rootController else { return }
    let viewControllers = navigationBuilder.build(item: linkItem)
    guard !viewControllers.isEmpty else { return }

    rootController.dismiss(animated: isAnimated) { [weak self] in
      guard let self else { return }
      subController?.clear(isAnimated: isAnimated)
      subController?.presentationController?.delegate = .none
    }

    rootController.replace(
      viewController: viewControllers,
      isAnimated: isAnimated)
  }

  /// Navigates backwards or forwards based on the first pick obtained from the navigation builder.
  ///
  /// - Parameters:
  ///   - linkItem: The link item containing the `ItemValue` to define the navigation endpoint.
  ///   - isAnimated: A flag indicating whether the navigation should be animated.
  private func _backOrNext(linkItem: LinkItem, isAnimated: Bool) {
    guard let activeController else { return }

    guard let pick = navigationBuilder.firstPick(controller: activeController, item: linkItem) else {
      activeController.push(
        viewController: navigationBuilder.pickBuild(item: linkItem),
        isAnimated: isAnimated)
      return
    }

    activeController.popToViewController(pick, animated: isAnimated)
  }

  /// Navigates backwards or forwards from the root controller based on the first pick from the navigation builder.
  ///
  /// - Parameters:
  ///   - linkItem: The link item containing the `ItemValue` to define the navigation endpoint.
  ///   - isAnimated: A flag indicating whether the navigation should be animated.
  private func _rootBackOrNext(linkItem: LinkItem, isAnimated: Bool) {
    guard let rootController else { return }

    guard let pick = navigationBuilder.firstPick(controller: rootController, item: linkItem) else {
      rootController.push(
        viewController: navigationBuilder.pickBuild(item: linkItem),
        isAnimated: isAnimated)
      return
    }

    rootController.popToViewController(pick, animated: isAnimated)
  }

// 다시
  /// Navigates backwards either through the sub navigator or the root controller based on the `isSubNavigatorActive` flag.
  ///
  /// - Parameter:
  ///   - isAnimated: A flag indicating whether the navigation should be animated.
  private func _back(isAnimated: Bool) {
    isSubNavigatorActive
      ? sheetBack(isAnimated: isAnimated)
      : rootController?.back(isAnimated: isAnimated)
  }

  /// Removes view controllers from the navigation stack based on the specified path list.
  ///
  /// - Parameter:
  ///   - pathList: An array of strings representing paths to be removed from the navigation stack.
  private func _remove(pathList: [String]) {
    guard let activeController else { return }
    activeController.setViewControllers(
      navigationBuilder.exceptFilter(
        controller: activeController,
        item: .init(pathList: pathList)),
      animated: false)
  }

  /// Removes view controllers from the root controller's navigation stack based on the specified path list.
  ///
  /// - Parameter:
  ///   - pathList: An array of strings representing paths to be removed from the navigation stack.
  private func _rootRemove(pathList: [String]) {
    guard let rootController else { return }
    rootController.setViewControllers(
      navigationBuilder.exceptFilter(
        controller: activeController,
        item: .init(pathList: pathList)),
      animated: false)
  }

  /// Navigates back to the last occurrence of the specified path.
  ///
  /// - Parameters:
  ///   - path: A string representing the path to navigate back to.
  ///   - isAnimated: A flag indicating whether the navigation should be animated.
  private func _backToLast(path: String, isAnimated: Bool) {
    activeController?.popTo(
      viewController: navigationBuilder.lastPick(
        controller: activeController,
        item: .init(path: path)),
      isAnimated: isAnimated)
  }

  /// Navigates back to the last occurrence of the specified path in the root controller's navigation stack.
  ///
  /// - Parameters:
  ///   - path: A string representing the path to navigate back to.
  ///   - isAnimated: A flag indicating whether the navigation should be animated.
  private func _rootBackToLast(path: String, isAnimated: Bool) {
    rootController?.popTo(
      viewController: navigationBuilder.lastPick(
        controller: activeController,
        item: .init(path: path)),
      isAnimated: isAnimated)
  }

  /// Closes the active controller if it is a sub controller and performs the specified completion action.
  ///
  /// - Parameters:
  ///   - isAnimated: A flag indicating whether the closure should be animated.
  ///   - completeAction: A closure to be executed upon completion of the closure action.
  private func _close(isAnimated: Bool, completeAction: @escaping () -> Void) {
    guard activeController == subController else { return }
    rootController?.dismiss(animated: isAnimated) { [weak self] in
      completeAction()
      self?.subController?.clear(isAnimated: false)
      self?.subController?.presentationController?.delegate = .none
    }
  }

   /// Retrieves a range of paths up to the specified path from the current paths in the root controller.
  ///
  /// - Parameter:
  ///   - path: A string representing the endpoint of the range retrieval.
  /// - Returns: An array of strings representing the range of paths retrieved.
  private func _range(path: String) -> [String] {
    getRootCurrentPaths().reduce([String]()) { current, next in
      guard current.contains(path) else { return current + [next] }
      return current
    }
  }

  /// Reloads the last view controller in the root controller's navigation stack with new items.
  ///
  /// - Parameters:
  ///   - items: The new `ItemValue` to be applied to the last view controller.
  ///   - isAnimated: A flag indicating whether the reload should be animated.
  private func _rootReloadLast(item: LinkItem, isAnimated _: Bool) {
    guard let lastPath = getRootCurrentPaths().last else { return }
    guard let rootController else { return }
    guard let new = routeBuilderItemList.first(where: { $0.matchPath == lastPath })?.routeBuild(self, item.encodedItemString, dependency)
    else { return }

    let newList = rootController.dropLast() + [new]
    rootController.replace(viewController: newList, isAnimated: false)
  }

  /// Presents an alert on the specified navigation target.
  ///
  /// - Parameters:
  ///   - target: The navigation target to present the alert on.
  ///   - model: The alert model defining the alert to be presented.
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
    item: LinkItem,
    isAnimated: Bool,
    prefersLargeTitles: Bool? = .none,
    presentWillAction: @escaping (UINavigationController) -> Void = { _ in },
    presentDidAction: @escaping (UINavigationController) -> Void = { _ in })
  {
    DispatchQueue.main.async { [weak self] in
      guard let self else { return }
      guard let rootController = self.rootController else { return }

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

extension SingleLinkNavigator: LinkNavigatorProtocol {
  public func next(linkItem: LinkItem, isAnimated: Bool) {
    _next(linkItem: linkItem, isAnimated: isAnimated)
  }

  public func rootNext(linkItem: LinkItem, isAnimated: Bool) {
    _rootNext(linkItem: linkItem, isAnimated: isAnimated)
  }

  public func sheet(linkItem: LinkItem, isAnimated: Bool) {
    _sheet(linkItem: linkItem, isAnimated: isAnimated)
  }

  public func fullSheet(linkItem: LinkItem, isAnimated: Bool, prefersLargeTitles: Bool?) {
    _fullSheet(linkItem: linkItem, isAnimated: isAnimated, prefersLargeTitles: prefersLargeTitles)
  }

  public func customSheet(
    linkItem: LinkItem,
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

  public func replace(linkItem: LinkItem, isAnimated: Bool) {
    _replace(linkItem: linkItem, isAnimated: isAnimated)
  }

  public func backOrNext(linkItem: LinkItem, isAnimated: Bool) {
    _backOrNext(linkItem: linkItem, isAnimated: isAnimated)
  }

  public func rootBackOrNext(linkItem: LinkItem, isAnimated: Bool) {
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

  public func rootReloadLast(items: LinkItem, isAnimated: Bool) {
    _rootReloadLast(item: items, isAnimated: isAnimated)
  }

  public func alert(target: NavigationTarget, model: Alert) {
    _alert(target: target, model: model)
  }

  public func send(item: LinkItem) {
    activeController?.viewControllers
      .compactMap { $0 as? MatchPathUsable }
      .filter { matchPathUsable in item.pathList.contains(matchPathUsable.matchPath) }
      .compactMap { $0 }
      .forEach {
        $0.eventSubscriber?.receive(encodedItemString: item.encodedItemString)
      }
  }

  public func rootSend(item: LinkItem) {
    rootController?.viewControllers
      .compactMap { $0 as? MatchPathUsable }
      .filter { item.pathList.contains($0.matchPath) }
      .forEach { subscriber in
        DispatchQueue.main.async {
          subscriber.eventSubscriber?.receive(encodedItemString: item.encodedItemString)
        }
      }
  }

  public func mainSend(item: LinkItem) {
    guard let owner else { return }
    DispatchQueue.main.async {
      owner.receive(encodedItemString: item.encodedItemString)
    }
  }

  public func allSend(item: LinkItem) {
    activeController?.viewControllers
      .compactMap { ($0 as? MatchPathUsable)?.eventSubscriber }
      .forEach { subscriber in
        DispatchQueue.main.async {
          subscriber.receive(encodedItemString: item.encodedItemString)
        }
      }
  }

  public func allRootSend(item: LinkItem) {
    rootController?.viewControllers
      .compactMap { ($0 as? MatchPathUsable)?.eventSubscriber }
      .forEach { subscriber in
        DispatchQueue.main.async {
          subscriber.receive(encodedItemString: item.encodedItemString)
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
