//import Foundation
//import UIKit
//
//// MARK: - LinkNavigatorProtocol
//
//public protocol LinkNavigatorProtocol {
//
//  typealias ItemValue = [String: String]
//
//  /// Navigates to the next view based on the specified link item.
//  ///
//  /// - Parameters:
//  ///   - linkItem: A LinkItem instance containing information for the navigation.
//  ///   - isAnimated: A Boolean indicating whether the transition should be animated or not.
//  func next(linkItem: LinkItem, isAnimated: Bool)
//
//  /// Navigates to the root view and then to the next view based on the specified link item.
//  ///
//  /// - Parameters:
//  ///   - linkItem: A LinkItem instance containing information for the navigation.
//  ///   - isAnimated: A Boolean indicating whether the transition should be animated or not.
//  func rootNext(linkItem: LinkItem, isAnimated: Bool)
//
//  /// Presents a view controller modally, styled as a sheet, based on the specified link item.
//  ///
//  /// - Parameters:
//  ///   - linkItem: A LinkItem instance containing information for the presentation.
//  ///   - isAnimated: A Boolean indicating whether the presentation should be animated or not.
//  func sheet(linkItem: LinkItem, isAnimated: Bool)
//
//  /// Presents a full-screen modal sheet based on the specified link item.
//  ///
//  /// - Parameters:
//  ///   - linkItem: A LinkItem instance containing information for the presentation.
//  ///   - isAnimated: A Boolean indicating whether the presentation should be animated or not.
//  ///   - prefersLargeTitles: An optional Boolean indicating the preference for large titles in the navigation bar.
//  func fullSheet(linkItem: LinkItem, isAnimated: Bool, prefersLargeTitles: Bool?)
//
//  /// Presents a modal sheet with custom presentation styles for iPhone and iPad.
//  ///
//  /// - Parameters:
//  ///   - linkItem: A LinkItem instance containing information for the presentation.
//  ///   - isAnimated: A Boolean indicating whether the presentation should be animated or not.
//  ///   - iPhonePresentationStyle: The presentation style to be used on iPhones.
//  ///   - iPadPresentationStyle: The presentation style to be used on iPads.
//  ///   - prefersLargeTitles: An optional Boolean indicating the preference for large titles in the navigation bar.
//  func customSheet(
//    linkItem: LinkItem,
//    isAnimated: Bool,
//    iPhonePresentationStyle: UIModalPresentationStyle,
//    iPadPresentationStyle: UIModalPresentationStyle,
//    prefersLargeTitles: Bool?)
//
//  /// Replaces the current view with a new view based on the specified link item.
//  ///
//  /// - Parameters:
//  ///   - linkItem: A LinkItem instance containing information for the replacement.
//  ///   - isAnimated: A Boolean indicating whether the transition should be animated or not.
//  func replace(linkItem: LinkItem, isAnimated: Bool)
//
//  /// Navigates back or forward based on the specified link item.
//  ///
//  /// - Parameters:
//  ///   - linkItem: A LinkItem instance containing information for the navigation.
//  ///   - isAnimated: A Boolean indicating whether the transition should be animated or not.
//  func backOrNext(linkItem: LinkItem, isAnimated: Bool)
//
//  /// Navigates back or forward from the root view based on the specified link item.
//  ///
//  /// - Parameters:
//  ///   - linkItem: A LinkItem instance containing information for the navigation.
//  ///   - isAnimated: A Boolean indicating whether the transition should be animated or not.
//  func rootBackOrNext(linkItem: LinkItem, isAnimated: Bool)
//
//  /// Navigates back to the previous view.
//  ///
//  /// - Parameter isAnimated: A Boolean indicating whether the transition should be animated or not.
//  func back(isAnimated: Bool)
//
//  /// Removes the views identified by the specified paths from the navigation stack.
//  ///
//  /// - Parameter pathList: A list of paths identifying the views to be removed.
//  func remove(pathList: [String])
//
//  /// Removes the views identified by the specified paths from the root of the navigation stack.
//  ///
//  /// - Parameter pathList: A list of paths identifying the views to be removed.
//  func rootRemove(pathList: [String])
//
//  /// Navigates back to the last occurrence of the specified path.
//  ///
//  /// - Parameters:
//  ///   - path: A string specifying the path to navigate back to.
//  ///   - isAnimated: A Boolean indicating whether the transition should be animated.
//  func backToLast(path: String, isAnimated: Bool)
//
//  /// Navigates back to the last occurrence of the specified path from the root view.
//  ///
//  /// - Parameters:
//  ///   - path: A string specifying the path to navigate back to from the root view.
//  ///   - isAnimated: A Boolean indicating whether the transition should be animated.
//  func rootBackToLast(path: String, isAnimated: Bool)
//
//  /// Closes the current view.
//  ///
//  /// - Parameters:
//  ///   - isAnimated: A Boolean indicating whether the transition should be animated.
//  ///   - completeAction: A closure to be executed after the view is closed.
//  func close(isAnimated: Bool, completeAction: @escaping () -> Void)
//
//  /// Retrieves the range of paths from the current to the specified path.
//  ///
//  /// - Parameter path: A string specifying the path to find the range to.
//  /// - Returns: An array of strings representing the range of paths.
//  func range(path: String) -> [String]
//
//  /// Reloads the last view in the root navigation stack with the specified items.
//  ///
//  /// - Parameters:
//  ///   - items: A dictionary of items to be used for reloading the view.
//  ///   - isAnimated: A Boolean indicating whether the reloading should be animated.
//  func rootReloadLast(items: ItemValue, isAnimated: Bool)
//
//  /// Displays an alert with the specified target and model. Depending on the target parameter,
//  /// the alert is displayed either on the root or the sub-controller.
//  ///
//  /// - Parameters:
//  ///   - target: The target specifying where to display the alert. It can be root, sub, or default.
//  ///             If the target is default, it determines whether to present the alert on sub or root based
//  ///             on the `isSubNavigatorActive` property.
//  ///   - model: The model containing information for building and displaying the alert.
//  func alert(target: NavigationTarget, model: Alert)
//
//  /// Sends the specified link item to a specific subscriber ('sub') or page sheet within the current navigation stack.
//  /// This method facilitates communication between pages, allowing data to be transferred to a specific 'sub' or page sheet as defined in the link item.
//  ///
//  /// - Parameter item: The link item encapsulating the data and the target path to be sent.
//  func send(item: LinkItem)
//
//  /// Sends the specified link item to the root controller which governs the page sheets (sub). This method is mainly used for communications directly involving the root controller which has overarching control over page sheets.
//  ///
//  /// - Parameter item: The link item to be sent to the root controller.
//  func rootSend(item: LinkItem)
//
//  /// Sends the main items directly to the appMain, which is a NavigationController that wraps around the link navigator. This method allows for data communication directly with the appMain, facilitating broad-reaching communications within the app.
//  ///
//  /// - Parameter item: The main items to be sent, often containing key-value pairs of data to be communicated to the appMain.
//  func mainSend(item: ItemValue)
//
//  /// Sends the specified items to all designated receivers, including both the 'sub' page sheets and the root controllers, within the current navigation stack. This allows for a widespread dissemination of data across various levels of the navigation stack.
//  ///
//  /// - Parameter item: The items to be sent to all receivers, encapsulating data that may be relevant across multiple page sheets and root controllers.
//  func allSend(item: ItemValue)
//
//  /// Sends the specified items to all root controllers in the navigation stack. This method is instrumental in disseminating information broadly at the root level, which governs the behaviors and states of the 'sub' page sheets.
//  ///
//  /// - Parameter item: The items to be sent to all root controllers, typically containing information pertinent across all root level pages.
//  func allRootSend(item: ItemValue)
//
//}
//
