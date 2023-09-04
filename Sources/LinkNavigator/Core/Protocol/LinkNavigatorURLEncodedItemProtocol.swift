import UIKit

// MARK: - EmptyValueType

public protocol EmptyValueType {
  static var empty: Self { get }
}

// MARK: - String + EmptyValueType

extension String: EmptyValueType {
  public static var empty: Self { "" }
}

// MARK: - EmptyValueType + EmptyValueType

extension [String: String]: EmptyValueType {
  public static var empty: [String: String] { [:] }
}

// MARK: - LinkNavigatorURLEncodedItemProtocol

/// `LinkNavigatorProtocol` defines the navigation interface for handling various link-related actions within an application.
public protocol LinkNavigatorURLEncodedItemProtocol {

  typealias ItemValue = String

  /// Navigates to the next link item.
  /// - Parameters:
  ///   - linkItem: The link item to navigate to.
  ///   - isAnimated: A Boolean value that determines whether the navigation is animated.
  func next(linkItem: LinkItem<ItemValue>, isAnimated: Bool)

  /// Navigates to the root next link item.
  /// - Parameters:
  ///   - linkItem: The link item to navigate to.
  ///   - isAnimated: A Boolean value that determines whether the navigation is animated.
  func rootNext(linkItem: LinkItem<ItemValue>, isAnimated: Bool)

  /// Presents a sheet with the given link item.
  /// - Parameters:
  ///   - linkItem: The link item to present.
  ///   - isAnimated: A Boolean value that determines whether the presentation is animated.
  func sheet(linkItem: LinkItem<ItemValue>, isAnimated: Bool)

  /// Presents a full sheet with the given link item.
  /// - Parameters:
  ///   - linkItem: The link item to present.
  ///   - isAnimated: A Boolean value that determines whether the presentation is animated.
  ///   - prefersLargeTitles: An optional Boolean value that determines whether the navigation bar should display large titles.
  func fullSheet(linkItem: LinkItem<ItemValue>, isAnimated: Bool, prefersLargeTitles: Bool?)

  /// Presents a custom sheet with the given link item.
  /// - Parameters:
  ///   - linkItem: The link item to present.
  ///   - isAnimated: A Boolean value that determines whether the presentation is animated.
  ///   - iPhonePresentationStyle: The presentation style for iPhone.
  ///   - iPadPresentationStyle: The presentation style for iPad.
  ///   - prefersLargeTitles: An optional Boolean value that determines whether the navigation bar should display large titles.
  func customSheet(
    linkItem: LinkItem<ItemValue>,
    isAnimated: Bool,
    iPhonePresentationStyle: UIModalPresentationStyle,
    iPadPresentationStyle: UIModalPresentationStyle,
    prefersLargeTitles: Bool?)

  /// Replaces the current link item.
  /// - Parameters:
  ///   - linkItem: The new link item.
  ///   - isAnimated: A Boolean value that determines whether the replacement is animated.
  func replace(linkItem: LinkItem<ItemValue>, isAnimated: Bool)

  /// Navigates back or to the next link item.
  /// - Parameters:
  ///   - linkItem: The link item to navigate to.
  ///   - isAnimated: A Boolean value that determines whether the navigation is animated.
  func backOrNext(linkItem: LinkItem<ItemValue>, isAnimated: Bool)

  /// Navigates back or to the root next link item.
  /// - Parameters:
  ///   - linkItem: The link item to navigate to.
  ///   - isAnimated: A Boolean value that determines whether the navigation is animated.
  func rootBackOrNext(linkItem: LinkItem<ItemValue>, isAnimated: Bool)

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
  func rootReloadLast(items: ItemValue, isAnimated: Bool)

  /// Presents an alert for the specified target and model.
  /// - Parameters:
  ///   - target: The target for the alert.
  ///   - model: The model for the alert.
  func alert(target: NavigationTarget, model: Alert)

  func send(item: LinkItem<ItemValue>)

  func rootSend(item: LinkItem<ItemValue>)

  func mainSend(item: ItemValue)

  func allSend(item: ItemValue)

  func allRootSend(item: ItemValue)
}
