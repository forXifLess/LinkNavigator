import Foundation

public protocol LinkNavigatorType: AnyObject {
  func back()
  func href(url: String, didOccuredError: ((LinkNavigatorType, LinkNavigatorError) -> Void)?)
  func replace(url: String, didOccuredError: ((LinkNavigatorType, LinkNavigatorError) -> Void)?) -> RootNavigator
  func alert(model: Alert)
}
