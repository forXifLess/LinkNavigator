import Foundation
import UIKit

/// Represents an item in a tab bar, encapsulating properties such as tag, title, icon, and a link item.
///
/// Generics:
/// - ItemValue: A type that conforms to `EmptyValueType`, representing the value associated with the link item.
public struct TabItem {

  /// A unique identifier string that is utilized as a tagID in `UITabBarItem`. This tag is essential in `TabLinkNavigator`
  /// to facilitate the addition, modification, and management of `LinkItem` instances in the `UINavigationController`
  /// associated with the respective ID in `UITabBarController`.
  public let tag: String

  /// An optional string representing the title of this tab item. This title corresponds to a `UITabBarItem` entry in the
  /// list of view controllers in the base `UINavigationController`. It is not mandatory to define this property if a custom
  /// approach is being used to handle tab bar items.
  public let title: String?

  /// An optional image representing the icon of this tab item. Similar to the `title` property, this icon represents a
  /// `UITabBarItem` entry within the base `UINavigationController`. This property can be left undefined in cases where
  /// a custom approach is used for tab bar item representation.
  public let icon: UIImage?

  /// A `LinkItem` instance encapsulating the associated values and paths for navigation linked with this tab item.
  public let linkItem: LinkItem

  /// Initializes a new instance of `TabItem`.
  ///
  /// - Parameters:
  ///   - tag: A unique string identifier to be used as a tagID in `UITabBarItem`, facilitating the management of navigation items in `TabLinkNavigator`.
  ///   - title: An optional string to be used as the title for the corresponding `UITabBarItem` within the base `UINavigationController`. This parameter can be omitted in custom implementations.
  ///   - icon: An optional image to be used as the icon for the corresponding `UITabBarItem` within the base `UINavigationController`. This parameter can be omitted in custom implementations.
  ///   - linkItem: A `LinkItem` instance defining the navigation properties and paths associated with this tab item.
  public init(tag: String, title: String?, icon: UIImage?, linkItem: LinkItem) {
    self.tag = tag
    self.title = title
    self.icon = icon
    self.linkItem = linkItem
  }
}
