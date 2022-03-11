import Foundation

public enum LinkTarget {
  case `default`
  case root
  case sheet
}

public protocol LinkNavigatorType: AnyObject {
  var isOpenedModal: Bool { get }

  func isCurrentContain(path: String) -> Bool

  func back(animated: Bool)
  func back(path: String, animated: Bool)
  func back(path: String, target: LinkTarget, animated: Bool)

  func dismiss(animated: Bool, didCompletion: (() -> Void)?)

  func alert(model: Alert)
  func alert(target: LinkTarget, model: Alert)

  func href(url: String, animated: Bool, didOccuredError: ((LinkNavigatorType, LinkNavigatorError) -> Void)?)
  func href(url: String, target: LinkTarget, animated: Bool, didOccuredError: ((LinkNavigatorType, LinkNavigatorError) -> Void)?)
  func href(paths: [String], parameters: [String: String], target: LinkTarget, animated: Bool, didOccuredError: ((LinkNavigatorType, LinkNavigatorError) -> Void)?)
  func href(paths: [String], target: LinkTarget, animated: Bool, didOccuredError: ((LinkNavigatorType, LinkNavigatorError) -> Void)?)
  func href(paths: [String], parameters: [String: String], animated: Bool, didOccuredError: ((LinkNavigatorType, LinkNavigatorError) -> Void)?)
  func href(paths: [String], animated: Bool, didOccuredError: ((LinkNavigatorType, LinkNavigatorError) -> Void)?)

  @discardableResult func replace(url: String, animated: Bool, didOccuredError: ((LinkNavigatorType, LinkNavigatorError) -> Void)?) -> RootNavigator
  @discardableResult func replace(paths: [String], parameters: [String: String], animated: Bool, didOccuredError: ((LinkNavigatorType, LinkNavigatorError) -> Void)?) -> RootNavigator
  @discardableResult func replace(paths: [String], animated: Bool, didOccuredError: ((LinkNavigatorType, LinkNavigatorError) -> Void)?) -> RootNavigator
  @discardableResult func replace(url: String, target: LinkTarget, animated: Bool, didOccuredError: ((LinkNavigatorType, LinkNavigatorError) -> Void)?) -> RootNavigator
  @discardableResult func replace(paths: [String], parameters: [String: String], target: LinkTarget, animated: Bool, didOccuredError: ((LinkNavigatorType, LinkNavigatorError) -> Void)?) -> RootNavigator
  @discardableResult func replace(paths: [String], target: LinkTarget, animated: Bool, didOccuredError: ((LinkNavigatorType, LinkNavigatorError) -> Void)?) -> RootNavigator
}
