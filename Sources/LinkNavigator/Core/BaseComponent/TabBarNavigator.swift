import UIKit

// MARK: - TabBarNavigator

public final class TabBarNavigator<ItemType> {

  // MARK: Lifecycle

  public init(
    navigator: Navigator<ItemType>,
    image: UIImage?,
    title: String?,
    tagMatchPath: String)
  {
    self.navigator = navigator
    self.image = image
    self.title = title
    self.tagMatchPath = tagMatchPath
  }

  // MARK: Public

  public let navigator: Navigator<ItemType>
  public let image: UIImage?
  public let title: String?
  public let tagMatchPath: String

}

extension TabBarNavigator {
  var tabBarItem: UITabBarItem {
    .init(title: title, image: image, tag: tagMatchPath.hashValue)
  }
}
