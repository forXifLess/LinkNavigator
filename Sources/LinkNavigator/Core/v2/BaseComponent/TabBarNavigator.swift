import UIKit

public final class TabBarNavigator {
  public let navigator: Navigator
  public let image: UIImage?
  public let title: String?
  public let tagName: String

  public init(
    navigator: Navigator,
    image: UIImage?,
    title: String?,
    tagName: String)
  {
    self.navigator = navigator
    self.image = image
    self.title = title
    self.tagName = tagName
  }
}

extension TabBarNavigator {
  var tabBarItem: UITabBarItem {
    .init(title: title, image: image, tag: tagName.hashValue)
  }
}
