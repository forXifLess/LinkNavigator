import UIKit

// MARK: - TabBarNavigator

public final class TabBarNavigator {

  // MARK: Lifecycle

  public init(
    navigator: Navigator,
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

  public let navigator: Navigator
  public let image: UIImage?
  public let title: String?
  public let tagMatchPath: String

}

extension TabBarNavigator {
  var tabBarItem: UITabBarItem {
    .init(title: title, image: image, tag: tagMatchPath.hashValue)
  }
}
