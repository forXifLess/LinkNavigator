import UIKit

public typealias MatchingViewController = MatchingKeyUsable & UIViewController

public protocol RouteBuilder {
	var matchPath: String { get }

  var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? { get }
}
