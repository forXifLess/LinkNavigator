import Foundation
import UIKit

/// Represents an item in a tab bar, holding a tag, a title, an icon, and a link item.
///
/// Generics:
/// - ItemValue: A type that conforms to `EmptyValueType`, representing the value associated with the link item.
public struct TabItem<ItemValue: EmptyValueType> {
  
  /// A string that uniquely identifies this tab item.
  public let tag: String
  
  /// An optional string that represents the title of this tab item.
  public let title: String?
  
  /// An optional image that represents the icon of this tab item.
  public let icon: UIImage?
  
  /// A `LinkItem` instance containing the associated values and paths for this tab item.
  public let linkItem: LinkItem<ItemValue>
}
