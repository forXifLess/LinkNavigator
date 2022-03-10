import Foundation

public protocol LinkNavigatorType: AnyObject {
  func back(animated: Bool)
  func href(url: String, didOccuredError: ((LinkNavigatorType, LinkNavigatorError) -> Void)?)
  func alert(model: Alert)
  func sheet(url: String, animated: Bool, didOccuredError: ((LinkNavigatorType, LinkNavigatorError) -> Void)?)

  @discardableResult
  func replace(url: String, didOccuredError: ((LinkNavigatorType, LinkNavigatorError) -> Void)?) -> RootNavigator
}
