import UIKit

public typealias MatchingViewController = MatchPathUsable & UIViewController

// MARK: - RouteBuilder

public protocol RouteBuilder {
  var matchPath: String { get }

  var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? { get }
}
