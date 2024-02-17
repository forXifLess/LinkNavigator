import Foundation
import UIKit

public struct TabItem {
  public let tag: Int
  public let tabItem: UITabBarItem?
  public let linkItem: LinkItem
  public let prefersLargeTitles: Bool

  public init(
    tag: Int,
    tabItem: UITabBarItem?,
    linkItem: LinkItem,
    prefersLargeTitles: Bool = false)
  {
    self.tag = tag
    self.tabItem = tabItem
    self.linkItem = linkItem
    self.prefersLargeTitles = prefersLargeTitles
  }
}
