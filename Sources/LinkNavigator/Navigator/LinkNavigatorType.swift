import Foundation

public enum LinkTarget {
  case `default`
  case root
  case sheet
}

public protocol LinkNavigatorType: AnyObject {
  var isOpenedModal: Bool { get }
  func back(animated: Bool)
  func dismiss(animated: Bool)
  func alert(model: Alert)
  func href(url: String, animated: Bool, didOccuredError: ((LinkNavigatorType, LinkNavigatorError) -> Void)?)
  func href(url: String, target: LinkTarget, animated: Bool, didOccuredError: ((LinkNavigatorType, LinkNavigatorError) -> Void)?)

  @discardableResult
  func replace(url: String, animated: Bool, didOccuredError: ((LinkNavigatorType, LinkNavigatorError) -> Void)?) -> RootNavigator

  @discardableResult
  func replace(url: String, target: LinkTarget, animated: Bool, didOccuredError: ((LinkNavigatorType, LinkNavigatorError) -> Void)?) -> RootNavigator
}
