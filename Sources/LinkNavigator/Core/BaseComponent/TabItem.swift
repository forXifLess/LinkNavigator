import Foundation
import UIKit

public struct TabItem {
  public let tag: Int
  public let tabItem: UITabBarItem?
  public let linkItem: LinkItem

  public init(tag: Int, tabItem: UITabBarItem?, linkItem: LinkItem) {
    self.tag = tag
    self.tabItem = tabItem
    self.linkItem = linkItem
  }
}
