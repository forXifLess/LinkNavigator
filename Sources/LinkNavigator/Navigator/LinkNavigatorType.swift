import Foundation

public protocol LinkNavigatorType: AnyObject {
  func back()
  func href(url: String)
  func replace(url: String)
}
