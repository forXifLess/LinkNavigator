import UIKit

// MARK: - LinkNavigatorURLEncodedItemProtocol

/// `LinkNavigatorURLEncodedItemProtocol` defines the navigation interface for handling various link-related actions within an application.
public protocol LinkNavigatorProtocol {

  /// Navigates to the next link item.
  /// 
  /// - Parameters:
  ///   - linkItem: The link item to navigate to.
  ///   - isAnimated: A Boolean value that determines whether the navigation is animated.
  func next(linkItem: LinkItem, isAnimated: Bool)

  /// Navigates to the root next link item.
  /// 
  /// - Parameters:
  ///   - linkItem: The link item to navigate to at the root level.
  ///   - isAnimated: A Boolean value that determines whether the navigation is animated.
  func rootNext(linkItem: LinkItem, isAnimated: Bool)

  /// Presents a sheet with the given link item.
  /// 
  /// - Parameters:
  ///   - linkItem: The link item to present.
  ///   - isAnimated: A Boolean value that determines whether the presentation is animated.
  func sheet(linkItem: LinkItem, isAnimated: Bool)

  /// Presents a full sheet with the given link item.
  /// 
  /// - Parameters:
  ///   - linkItem: The link item to present.
  ///   - isAnimated: A Boolean value that determines whether the presentation is animated.
  ///   - prefersLargeTitles: An optional Boolean value that determines whether the navigation bar should display large titles.
  func fullSheet(linkItem: LinkItem, isAnimated: Bool, prefersLargeTitles: Bool?)

  /// Presents a custom sheet with the specified characteristics.
  /// 
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

  /// Replaces the current link item with the given link item.
  /// 
  /// - Parameters:
  ///   - linkItem: The new link item to replace the current one.
  ///   - isAnimated: A Boolean value that determines whether the replacement is animated.
  func replace(linkItem: LinkItem, isAnimated: Bool)

  /// Navigates either back or to the next link item based on the current state.
  /// 
  /// - Parameters:
  ///   - linkItem: The link item to navigate to or back from.
  ///   - isAnimated: A Boolean value that determines whether the navigation is animated.
  func backOrNext(linkItem: LinkItem, isAnimated: Bool)

  /// Navigates either back or to the root next link item based on the current state.
  /// 
  /// - Parameters:
  ///   - linkItem: The link item to navigate to or back from at the root level.
  ///   - isAnimated: A Boolean value that determines whether the navigation is animated.
  func rootBackOrNext(linkItem: LinkItem, isAnimated: Bool)

  /// Navigates back in the navigation stack.
  /// 
  /// - Parameter isAnimated: A Boolean value that determines whether the navigation is animated.
  func back(isAnimated: Bool)

  /// Removes the specified paths from the navigation stack.
  /// 
  /// - Parameter pathList: A list of paths to remove.
  func remove(pathList: [String])
  
  /// Removes the specified paths at the root level from the navigation stack.
  ///
  /// - Parameter pathList: A list of paths to remove from the root of the navigation stack.
  func rootRemove(pathList: [String])

  /// Navigates back to the last specified path.
  ///
  /// - Parameters:
  ///   - path: The path to navigate back to.
  ///   - isAnimated: A Boolean value indicating whether the navigation should be animated.
  func backToLast(path: String, isAnimated: Bool)

  /// Navigates back to the last specified root path.
  ///
  /// - Parameters:
  ///   - path: The root path to navigate back to.
  ///   - isAnimated: A Boolean value indicating whether the navigation should be animated.
  func rootBackToLast(path: String, isAnimated: Bool)

  /// Closes the navigation interface.
  ///
  /// - Parameters:
  ///   - isAnimated: A Boolean value indicating whether the close action should be animated.
  ///   - completeAction: A closure that gets called when the close action is complete.
  func close(isAnimated: Bool, completeAction: @escaping () -> Void)

  /// Returns the range of paths for the specified path.
  ///
  /// - Parameter path: The path to get the range for.
  /// - Returns: An array of paths representing the range.
  func range(path: String) -> [String]

  /// Reloads the last root item with the specified items.
  ///
  /// - Parameters:
  ///   - items: A string representing the raw QueryString for the items to reload.
  ///   - isAnimated: A Boolean value indicating whether the reload should be animated.
  func rootReloadLast(items: LinkItem, isAnimated: Bool)

  /// Displays an alert with the specified target and model. Depending on the target parameter, 
  /// the alert is displayed either on the root or the sub-controller.
  ///
  /// - Parameters:
  ///   - target: The target specifying where to display the alert. It can be root, sub, or default.
  ///             If the target is default, it determines whether to present the alert on sub or root based 
  ///             on the `isSubNavigatorActive` property.
  ///   - model: The model containing information for building and displaying the alert.
  func alert(target: NavigationTarget, model: Alert)
  
  /// Sends the specified link item to a specific subscriber ('sub') or page sheet within the current navigation stack.
  /// This method facilitates communication between pages, allowing data to be transferred to a specific 'sub' or page sheet as defined in the link item.
  ///
  /// - Parameter item: The link item encapsulating the data and the target path to be sent.
  func send(item: LinkItem)

  /// Sends the specified link item to the root controller which governs the page sheets (sub). This method is mainly used for communications directly involving the root controller which has overarching control over page sheets.
  ///
  /// - Parameter item: The link item to be sent to the root controller.
  func rootSend(item: LinkItem)

  /// Sends the main items directly to the appMain, which is a NavigationController that wraps around the link navigator. This method allows for data communication directly with the appMain, facilitating broad-reaching communications within the app.
  ///
  /// - Parameter item: The main items to be sent, often containing key-value pairs of data to be communicated to the appMain.
  func mainSend(item: LinkItem)

  /// Sends the specified items to all designated receivers, including both the 'sub' page sheets and the root controllers, within the current navigation stack. This allows for a widespread dissemination of data across various levels of the navigation stack.
  ///
  /// - Parameter item: The items to be sent to all receivers, encapsulating data that may be relevant across multiple page sheets and root controllers.
  func allSend(item: LinkItem)

  /// Sends the specified items to all root controllers in the navigation stack. This method is instrumental in disseminating information broadly at the root level, which governs the behaviors and states of the 'sub' page sheets.
  ///
  /// - Parameter item: The items to be sent to all root controllers, typically containing information pertinent across all root level pages.
  func allRootSend(item: LinkItem)
}
