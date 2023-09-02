import Foundation
import UIKit

public struct TabItem<ItemType> {
  let tagID: String
  let linkItem: LinkItem<ItemType>
  let title: String?
  let image: UIImage?

  public init(
    tagID: String,
    linkItem: LinkItem<ItemType>,
    title: String?,
    image: UIImage?)
  {
    self.tagID = tagID
    self.linkItem = linkItem
    self.title = title
    self.image = image
  }
}

extension TabItem: Equatable {
  public static func == (lhs: Self, rhs: Self) -> Bool {
    return lhs.tagID == rhs.tagID
    && lhs.linkItem == rhs.linkItem
  }
}

extension TabItem {
  var tabBarItem: UITabBarItem {
    .init(title: title, image: image, tag: tagID.hashValue)
  }
}
