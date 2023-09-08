import Foundation
import SwiftUI

/// Represents a navigational view that leverages a `TabLinkNavigator` to manage tab-based navigation.
///
/// This struct encapsulates the navigation logic for a tab-based user interface. It maintains a list of `TabItem` instances,
/// each of which contains the necessary information (like TagID, tab bar image, tab bar title, and UINavigationController)
/// to represent an individual tab. These tab items have their own `LinkNavigator` which can further process additional
/// information using `LinkItem`.
public struct TabLinkNavigationView<ItemValue: EmptyValueType> {

  /// A `TabLinkNavigator` instance that handles the navigation actions between different tabs.
  let linkNavigator: TabLinkNavigator<ItemValue>

  /// A list of `TabItem` instances that define the individual tabs in the tab-based user interface.
  ///
  /// These items hold the necessary information for each tab and define the pages to be displayed when the app is
  /// initially set up via SwiftUI.
  let tabItemList: [TabItem<ItemValue>]

  /// Initializes a new instance of `TabLinkNavigationView`.
  ///
  /// - Parameters:
  ///   - linkNavigator: A `TabLinkNavigator` instance used to manage the navigational actions between tabs.
  ///   - tabItemList: A list of `TabItem` instances that define the individual tabs and their associated pages.
  public init(linkNavigator: TabLinkNavigator<ItemValue>, tabItemList: [TabItem<ItemValue>]) {
    self.linkNavigator = linkNavigator
    self.tabItemList = tabItemList
  }
}

// MARK: - UIViewControllerRepresentable

extension TabLinkNavigationView: UIViewControllerRepresentable {

  /// Creates a `UITabBarController` instance that initially sets up the view controllers based on the `TabItem` list.
  ///
  /// - Parameter context: The context in which the `UITabBarController` is created.
  ///
  /// - Returns: A `UITabBarController` instance that serves as the main controller for tab-based navigation.
  public func makeUIViewController(context _: Context) -> UITabBarController {
    let vc = UITabBarController()
    vc.setViewControllers(linkNavigator.launch(tagItemList: tabItemList), animated: false)
    vc.tabBar.isHidden = true
    return vc
  }

  /// Updates the `mainController` of the `linkNavigator` with the provided `UITabBarController` instance.
  ///
  /// - Parameters:
  ///   - uiViewController: The `UITabBarController` instance that serves as the main controller for the tab-based navigation.
  ///   - context: The context in which the update occurs.
  public func updateUIViewController(_ uiViewController: UITabBarController, context _: Context) {
    linkNavigator.mainController = uiViewController
  }
}
