import Foundation
import SwiftUI

/// Represents a view for navigation using `SingleLinkNavigator`.
///
/// This struct is used to initialize a navigation view with a link navigator and a link item. The link navigator
/// facilitates various navigation actions such as adding, removing, or presenting sheets using a `UINavigationController`.
/// The link item holds information about the path of the page to be requested by the navigator and the details of the
/// item to be injected into the page. The `item` parameter in the initializer represents the `UINavigationController`
/// stack that will be injected and displayed to the user once the view is rendered.
public struct LinkNavigationView {

  /// A `SingleLinkNavigator` instance that handles various navigation actions.
  let linkNavigator: SingleLinkNavigator

  /// A `LinkItem` instance that contains information about the page to be requested and the item to be injected.
  let item: LinkItem

  let prefersLargeTitles: Bool

  /// Initializes a new instance of `LinkNavigationView`.
  ///
  /// - Parameters:
  ///   - linkNavigator: A `SingleLinkNavigator` instance used for navigating between pages.
  ///   - item: A `LinkItem` instance that contains the path and item details for the page to be requested.
  public init(linkNavigator: SingleLinkNavigator, item: LinkItem, prefersLargeTitles: Bool = false) {
    self.linkNavigator = linkNavigator
    self.item = item
    self.prefersLargeTitles = prefersLargeTitles
  }
}

// MARK: - UIViewControllerRepresentable

extension LinkNavigationView: UIViewControllerRepresentable {

  /// Creates a `UINavigationController` instance that is initially populated with view controllers
  /// based on the `LinkItem` instance provided during initialization.
  ///
  /// - Parameter context: The context in which the `UIViewController` is created.
  ///
  /// - Returns: A `UINavigationController` instance that serves as the base for navigation actions.
  public func makeUIViewController(context _: Context) -> UINavigationController {
    let vc = UINavigationController()
    vc.navigationBar.prefersLargeTitles = prefersLargeTitles
    vc.setViewControllers(linkNavigator.launch(item: item), animated: false)
    return vc
  }

  /// Updates the `rootController` of the `linkNavigator` with the provided `UINavigationController` instance.
  ///
  /// This method allows the update of pages based on the `UINavigationController`, facilitating page updates whenever the view updates.
  ///
  /// - Parameters:
  ///   - uiViewController: The `UINavigationController` instance that serves as the base for navigation actions.
  ///   - context: The context in which the update occurs.
  public func updateUIViewController(_ uiViewController: UINavigationController, context _: Context) {
    linkNavigator.rootController = uiViewController
  }
}
