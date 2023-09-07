import Foundation
import UIKit

/// `TabPartialNavigator` is a class that facilitates navigation through tabs within an application. 
/// It helps manage the navigation stack for each tab while holding a reference to the root navigator and other necessary dependencies.
///
/// - Note: 
///     - `ItemValue`: The parameter value injected when creating a page. This type can provide `String` or `[String]` type values.
///     - `TabLinkNavigator`: Allows the addition, removal, or modification of the next page on each page. It can also facilitate functionalities like adding pages, removing pages, or going back using this navigator in a page.
///     - `RouteBuilderOf`: A builder responsible for creating pages. During the creation, it takes `ItemValue`, `RootNavigator`, and `Dependency` as parameters to facilitate the page construction.
///     - `DependencyType`: Required to inject project-wide utilities such as MVI SideEffect, analogous to UseCase in clean architecture.
public final class TabPartialNavigator<ItemValue: EmptyValueType> {

  // MARK: - Lifecycle
  
  /// Initializes a new instance of `TabPartialNavigator`.
  ///
  /// - Parameters:
  ///   - rootNavigator: A reference to the root navigator, which is optionally provided, to manage functionalities like adding or removing pages and going back.
  ///   - tabItem: A `TabItem` instance that represents the specific tab associated with this navigator.
  ///   - routeBuilderItemList: An array of `RouteBuilderOf` instances that help in constructing the navigation flow within the tab, providing the necessary parameters for page creation.
  ///   - dependency: A `DependencyType` parameter that represents the dependencies required for the navigator, primarily for injecting utilities such as MVI SideEffect.
  public init(
    rootNavigator: TabLinkNavigator<ItemValue>?,
    tabItem: TabItem<ItemValue>,
    routeBuilderItemList: [RouteBuilderOf<TabPartialNavigator, ItemValue>],
    dependency: DependencyType)
  {
    self.rootNavigator = rootNavigator
    self.tabItem = tabItem
    self.routeBuilderItemList = routeBuilderItemList
    self.dependency = dependency
  }

  // MARK: - Public Properties

  /// A `TabItem` instance representing the tab associated with this navigator.
  public let tabItem: TabItem<ItemValue>
  
  /// A list of `RouteBuilderOf` instances that define the navigation flow within the tab, assisting in page creation by providing necessary parameters.
  public let routeBuilderItemList: [RouteBuilderOf<TabPartialNavigator, ItemValue>]
  
  /// A `DependencyType` instance representing the dependencies required for the navigator, aiding in the injection of project-wide utilities such as MVI SideEffect.
  public let dependency: DependencyType
  
  /// The root navigation controller associated with this navigator.
  public var rootController: UINavigationController = .init()
  
  /// A Boolean value indicating whether the current tab is focused.
  public var isFocusedCurrentTab: Bool {
    rootNavigator?.tabPartialNavigators.first(where: { $0.rootController == rootController })?.tabItem.tag == tabItem.tag
  }

  // MARK: - Private Properties
  
  /// A weak reference to the root navigator (`TabLinkNavigator`) that manages the tab navigators, offering functionalities like page addition, removal, and back navigation.
  private weak var rootNavigator: TabLinkNavigator<ItemValue>?

  /// A computed property that returns the current navigation controller. 
  /// It checks various controllers from the root navigator and returns the appropriate one.
  private var currentController: UINavigationController? {
    rootNavigator?.modalController != .none
      ? rootNavigator?.modalController
      : rootNavigator?.fullSheetController != .none
        ? rootNavigator?.fullSheetController
        : rootController
  }
}

// MARK: LinkNavigatorFindLocationUsable

/// Extension of `TabPartialNavigator` conforming to `LinkNavigatorFindLocationUsable` protocol.
/// This extension implements methods to fetch current paths in navigation stack and to navigate to a different tab based on its tag.
extension TabPartialNavigator: LinkNavigatorFindLocationUsable {
  
  /// Fetches the current navigation paths in the navigation stack of the current controller.
  ///
  /// - Returns: An array of strings representing the current paths in the navigation stack. Returns an empty array if the `currentController` is nil.
  public func getCurrentPaths() -> [String] {
    currentController?.currentItemList() ?? []
  }

  /// Fetches the current navigation paths in the navigation stack of the root controller.
  ///
  /// - Returns: An array of strings representing the current paths in the navigation stack of the root controller.
  public func getRootCurrentPaths() -> [String] {
    rootController.currentItemList()
  }
}

/// Additional extension of `TabPartialNavigator` to facilitate navigation between different tabs.
extension TabPartialNavigator {
  
  /// Moves the navigation to a tab identified by a specific tag.
  ///
  /// - Parameters:
  ///   - targetTag: A string representing the tag of the target tab to navigate to.
  public func moveTab(targetTag: String) {
    rootNavigator?.moveTab(targetTag: targetTag)
  }
}

extension TabPartialNavigator {

  /// Launches a new tab with specified link item or default tab item link item, and sets the view controllers of the root controller to the newly created view controllers.
  ///
  /// - Parameters:
  ///   - item: The link item to be launched, defaults to nil.
  ///   - prefersLargeTitles: A boolean indicating whether the new tab should prefer large titles, defaults to false.
  /// - Returns: An array of view controllers set to the root controller.
  public func launch(item: LinkItem<ItemValue>? = .none, prefersLargeTitles _: Bool = false) -> [UIViewController] {
    let viewControllers = NavigatorBuilder.build(
      rootNavigator: self,
      item: item ?? tabItem.linkItem,
      routeBuilderList: routeBuilderItemList,
      dependency: dependency)

    rootController.setViewControllers(viewControllers, animated: false)
    return viewControllers
  }

  /// Navigates to the next page represented by the specified link item with an option to animate the transition.
  ///
  /// - Parameters:
  ///   - linkItem: The link item representing the next page.
  ///   - isAnimated: A boolean indicating whether the transition should be animated.
  public func next(linkItem: LinkItem<ItemValue>, isAnimated: Bool) {
    currentController?.merge(
      new: NavigatorBuilder.build(
        rootNavigator: self,
        item: linkItem,
        routeBuilderList: routeBuilderItemList,
        dependency: dependency),
      isAnimated: isAnimated)
  }

  /// Similar to `next(linkItem:isAnimated:)` but operates on the root controller.
  public func rootNext(linkItem: LinkItem<ItemValue>, isAnimated: Bool) {
    rootController.merge(
      new: NavigatorBuilder.build(
        rootNavigator: self,
        item: linkItem,
        routeBuilderList: routeBuilderItemList,
        dependency: dependency),
      isAnimated: isAnimated)
  }

  /// Navigates back to the previous page with an option to animate the transition.
  ///
  /// - Parameters:
  ///   - isAnimated: A boolean indicating whether the transition should be animated.
  public func back(isAnimated: Bool) {
    currentController?.back(isAnimated: isAnimated)
  }

  /// Similar to `back(isAnimated:)` but operates on the root controller.
  public func rootBack(isAnimated: Bool) {
    rootController.back(isAnimated: isAnimated)
  }

  /// Navigates back to a specific view controller identified by the link item or navigates to a new page represented by the link item with an option to animate the transition.
  ///
  /// - Parameters:
  ///   - linkItem: The link item representing the target page.
  ///   - isAnimated: A boolean indicating whether the transition should be animated.
  public func backOrNext(linkItem: LinkItem<ItemValue>, isAnimated: Bool) {
    guard
      let pick = NavigatorBuilder.firstPick(
        controller: currentController,
        item: linkItem)
    else {
      return
    }

    currentController?.popToViewController(pick, animated: isAnimated)
  }

  /// Similar to `backOrNext(linkItem:isAnimated:)` but operates on the root controller.
  public func rootBackOrNext(linkItem: LinkItem<ItemValue>, isAnimated: Bool) {
    guard
      let pick = NavigatorBuilder.firstPick(
        controller: currentController,
        item: linkItem)
    else {
      return
    }

    rootController.popToViewController(pick, animated: isAnimated)
  }

  /// Replaces the current view controller with a new one represented by the link item with an option to animate the transition.
  ///
  /// - Parameters:
  ///   - linkItem: The link item representing the new page.
  ///   - isAnimated: A boolean indicating whether the transition should be animated.
  public func replace(linkItem: LinkItem<ItemValue>, isAnimated: Bool) {
    currentController?.replace(
      viewController: NavigatorBuilder.build(
        rootNavigator: self,
        item: linkItem,
        routeBuilderList: routeBuilderItemList,
        dependency: dependency),
      isAnimated: isAnimated)
  }

  /// Similar to `replace(linkItem:isAnimated:)` but operates on the root controller.
  public func rootReplace(linkItem: LinkItem<ItemValue>, isAnimated: Bool) {
    rootController.replace(
      viewController: NavigatorBuilder.build(
        rootNavigator: self,
        item: linkItem,
        routeBuilderList: routeBuilderItemList,
        dependency: dependency),
      isAnimated: isAnimated)
  }

  /// Removes view controllers with paths specified in the path list from the current controller's navigation stack.
  ///
  /// - Parameters:
  ///   - pathList: A list of strings representing paths to be removed.
  public func remove(pathList: [String]) {
    currentController?.setViewControllers(
      NavigatorBuilder.exceptFilter(
        controller: currentController,
        item: .init(pathList: pathList, items: ItemValue.empty)),
      animated: false)
  }

  /// Similar to `remove(pathList:)` but operates on the root controller.
  public func rootRemove(pathList: [String]) {
    rootController.setViewControllers(
      NavigatorBuilder.exceptFilter(
        controller: rootController,
        item: .init(pathList: pathList, items: ItemValue.empty)),
      animated: false)
  }

  /// Navigates back to the last occurrence of a specific path in the current controller's navigation stack with an option to animate the transition.
  ///
  /// - Parameters:
  ///   - path: A string representing the target path.
  ///   - isAnimated: A boolean indicating whether the transition should be animated.
  public func backToLast(path: String, isAnimated: Bool) {
    currentController?.popTo(
      viewController: NavigatorBuilder.lastPick(
        controller: currentController,
        item: .init(path: path, items: ItemValue.empty)),
      isAnimated: isAnimated)
  }

  /// Similar to `backToLast(path:isAnimated:)` but operates on the root controller.
  public func rootBackToLast(path: String, isAnimated: Bool) {
    rootController.popTo(
      viewController: NavigatorBuilder.lastPick(
        controller: rootController,
        item: .init(path: path, items: ItemValue.empty)),
      isAnimated: isAnimated)
  }

  /// Retrieves a list of paths up to a specified path from the root controller's current paths.
  ///
  /// - Parameters:
  ///   - path: A string representing the target path.
  /// - Returns: A list of strings representing the paths.
  public func range(path: String) -> [String] {
    getRootCurrentPaths().reduce([String]()) { current, next in
      guard current.contains(path) else { return current + [next] }
      return current
    }
  }

  /// Opens a new sheet with specified link item, animation option and presentation style.
  ///
  /// - Parameters:
  ///   - item: The link item representing the page to be presented in the sheet.
  ///   - isAnimated: A boolean indicating whether the presentation should be animated.
  ///   - type: The modal presentation style for the sheet, defaults to automatic.
  public func sheetOpen(
    item: LinkItem<ItemValue>,
    isAnimated: Bool,
    type: UIModalPresentationStyle = .automatic)
  {
    let newController = UINavigationController()

    newController.setViewControllers(
      NavigatorBuilder
        .build(
          rootNavigator: self,
          item: item,
          routeBuilderList: routeBuilderItemList,
          dependency: dependency),
      animated: false)

    rootNavigator?.sheetOpen(
      subViewController: newController,
      isAnimated: isAnimated,
      type: type,
      presentWillAction: {
        $0.modalPresentationStyle = type
      })
  }

  /// Closes the currently opened sheet view controller. This method is part of the `TabLinkNavigator` class, allowing various navigation functionalities such as adding, removing, or modifying pages. It also enables navigating backwards, adding new pages, and deleting existing ones.
  ///
  /// This function triggers a closure method on the `rootNavigator`, which is responsible for managing the navigation stack, to close the currently opened sheet (if any). It is recommended to use this function when you want to programmatically dismiss the current sheet and return to the previous view in the navigation stack.
  ///
  /// - Parameters:
  ///   - isAnimated: A boolean value indicating whether the closing transition should be animated.
  public func close(isAnimated: Bool) {
    rootNavigator?.close(isAnimated: isAnimated)
  }

  /// Closes all open sheet view controllers in the navigation stack. This method is an essential function of the `TabLinkNavigator` class that enables resetting the navigation stack to a pristine state by closing all open sheets programmatically.
  ///
  /// This function triggers a closure method on the `rootNavigator`, which controls the navigation stack, to close all currently opened sheets, effectively returning to the base view controller in the stack. It serves a vital role in managing the project's navigation flow, particularly in creating pages and injecting necessary dependencies such as `ItemValue`, `DependencyType`, and facilitating the use of the `RouteBuilderOf` class for page creation.
  ///
  /// - Parameters:
  ///   - isAnimated: A boolean value that dictates whether the transition should be animated. If set to true, the closing transition for all the sheets will be animated, providing a smooth transition experience to the user. If set to false, the sheets will close instantly without any animations.
  public func closeAll(isAnimated: Bool) {
    rootNavigator?.closeAll(isAnimated: isAnimated)
  }

}

extension UINavigationController {

  // MARK: Fileprivate

  /// Retrieves a list of match paths from the current view controllers.
  ///
  /// - Returns: An array of strings representing match paths of the current view controllers.
  fileprivate func currentItemList() -> [String] {
    viewControllers.compactMap { $0 as? MatchPathUsable }.map(\.matchPath)
  }

  /// Merges the given view controllers with the current view controllers and sets the result as the new view controllers stack with an option to animate the transition.
  ///
  /// - Parameters:
  ///   - new: An array of view controllers to be merged with the current view controllers.
  ///   - isAnimated: A boolean indicating whether the transition should be animated.
  fileprivate func merge(new: [UIViewController], isAnimated: Bool) {
    setViewControllers(viewControllers + new, animated: isAnimated)
  }

  /// Navigates back to the previous view controller in the navigation stack with an option to animate the transition.
  ///
  /// - Parameters:
  ///   - isAnimated: A boolean indicating whether the transition should be animated.
  fileprivate func back(isAnimated: Bool) {
    popViewController(animated: isAnimated)
  }

  /// Replaces the current view controllers stack with the given view controllers with an option to animate the transition.
  ///
  /// - Parameters:
  ///   - viewController: An array of view controllers to set as the new stack.
  ///   - isAnimated: A boolean indicating whether the transition should be animated.
  fileprivate func replace(viewController: [UIViewController], isAnimated: Bool) {
    setViewControllers(viewController, animated: isAnimated)
  }

  /// Pops view controllers up to the specified view controller with an option to animate the transition.
  ///
  /// - Parameters:
  ///   - viewController: The target view controller to pop to.
  ///   - isAnimated: A boolean indicating whether the transition should be animated.
  fileprivate func popTo(viewController: UIViewController?, isAnimated: Bool) {
    guard let viewController = viewController else { return }
    popToViewController(viewController, animated: isAnimated)
  }

  // MARK: Private

  /// Clears all view controllers in the navigation stack with an option to animate the transition.
  ///
  /// - Parameters:
  ///   - isAnimated: A boolean indicating whether the transition should be animated.
  private func clear(isAnimated: Bool) {
    setViewControllers([], animated: isAnimated)
  }

  /// Pushes the given view controller onto the navigation stack with an option to animate the transition.
  ///
  /// - Parameters:
  ///   - viewController: The view controller to be pushed onto the stack.
  ///   - isAnimated: A boolean indicating whether the transition should be animated.
  private func push(viewController: UIViewController?, isAnimated: Bool) {
    guard let viewController = viewController else { return }
    pushViewController(viewController, animated: isAnimated)
  }

  /// Drops the last view controller from the navigation stack and returns the modified stack.
  ///
  /// - Returns: An array of view controllers excluding the last one.
  private func dropLast() -> [UIViewController] {
    Array(viewControllers.dropLast())
  }
}

