import UIKit

/// `LinkNavigatorProtocol` defines the navigation interface for handling various link-related actions within an application.
public protocol LinkNavigatorProtocol {

  /// The Main navigator.
  var rootNavigator: Navigator { get }

  /// The sub navigation (Managed the Root present Navigation Stack)
  var subNavigator: Navigator? { get }

  /// The active navigator.
  var activeNavigator: Navigator? { get }

  /// A Boolean value indicating whether a sub-navigator is active.
  var isSubNavigatorActive: Bool { get }

  /// An array containing the current paths.
  var currentPaths: [String] { get }

  /// An array containing the root current paths.
  var rootCurrentPaths: [String] { get }

  /// Navigates to the next link item.
  /// - Parameters:
  ///   - linkItem: The link item to navigate to.
  ///   - isAnimated: A Boolean value that determines whether the navigation is animated.
  func next(linkItem: LinkItem, isAnimated: Bool)

  /// Navigates to the root next link item.
  /// - Parameters:
  ///   - linkItem: The link item to navigate to.
  ///   - isAnimated: A Boolean value that determines whether the navigation is animated.
  func rootNext(linkItem: LinkItem, isAnimated: Bool)

  /// Presents a sheet with the given link item.
  /// - Parameters:
  ///   - linkItem: The link item to present.
  ///   - isAnimated: A Boolean value that determines whether the presentation is animated.
  func sheet(linkItem: LinkItem, isAnimated: Bool)

  /// Presents a full sheet with the given link item.
  /// - Parameters:
  ///   - linkItem: The link item to present.
  ///   - isAnimated: A Boolean value that determines whether the presentation is animated.
  ///   - prefersLargeTitles: An optional Boolean value that determines whether the navigation bar should display large titles.
  func fullSheet(linkItem: LinkItem, isAnimated: Bool, prefersLargeTitles: Bool?)

  /// Presents a custom sheet with the given link item.
  /// - Parameters:
  ///   - linkItem: The link item to present.
  ///   - isAnimated: A Boolean value that determines whether the presentation is animated.
  ///   - iPhonePresentationStyle: The presentation style for iPhone.
  ///   - iPadPresentationStyle: The presentation style for iPad.
  ///   - prefersLargeTitles: An optional Boolean value that determines whether the navigation bar should display large titles.
  func customSheet(
    linkItem: LinkItem,
    isAnimated: Bool,
    iPhonePresentationStyle: UIModalPresentationStyle,
    iPadPresentationStyle: UIModalPresentationStyle,
    prefersLargeTitles: Bool?)

  /// Replaces the current link item.
  /// - Parameters:
  ///   - linkItem: The new link item.
  ///   - isAnimated: A Boolean value that determines whether the replacement is animated.
  func replace(linkItem: LinkItem, isAnimated: Bool)

  /// Navigates back or to the next link item.
  /// - Parameters:
  ///   - linkItem: The link item to navigate to.
  ///   - isAnimated: A Boolean value that determines whether the navigation is animated.
  func backOrNext(linkItem: LinkItem, isAnimated: Bool)

  /// Navigates back or to the root next link item.
  /// - Parameters:
  ///   - linkItem: The link item to navigate to.
  ///   - isAnimated: A Boolean value that determines whether the navigation is animated.
  func rootBackOrNext(linkItem: LinkItem, isAnimated: Bool)

  /// Navigates back.
  /// - Parameter isAnimated: A Boolean value that determines whether the navigation is animated.
  func back(isAnimated: Bool)

  /// Removes the specified paths.
  /// - Parameter pathList: An array of paths to remove.
  func remove(pathList: [String])

  /// Removes the specified root paths.
  /// - Parameter pathList: An array of root paths to remove.
  func rootRemove(pathList: [String])

  /// Navigates back to the last specified path.
  /// - Parameters:
  ///   - path: The path to navigate back to.
  ///   - isAnimated: A Boolean value that determines whether the navigation is animated.
  func backToLast(path: String, isAnimated: Bool)

  /// Navigates back to the last specified root path.
  /// - Parameters:
  ///   - path: The root path to navigate back to.
  ///   - isAnimated: A Boolean value that determines whether the navigation is animated.
  func rootBackToLast(path: String, isAnimated: Bool)

  /// Closes the navigation.
  /// - Parameters:
  ///   - isAnimated: A Boolean value that determines whether the close is animated.
  ///   - completeAction: A closure that gets called when the close is complete.
  func close(isAnimated: Bool, completeAction: @escaping () -> Void)

  /// Returns the range of paths for the specified path.
  /// - Parameter path: The path to get the range for.
  /// - Returns: An array of paths that represent the range.
  func range(path: String) -> [String]

  /// Reloads the last root item with the specified items.
  /// - Parameters:
  ///   - items: raw QueryString for the items to reload.
  ///   - isAnimated: A Boolean value that determines whether the reload is animated.
  func rootReloadLast(items: String, isAnimated: Bool)

  /// Presents an alert for the specified target and model.
  /// - Parameters:
  ///   - target: The target for the alert.
  ///   - model: The model for the alert.
  func alert(target: NavigationTarget, model: Alert)

}
