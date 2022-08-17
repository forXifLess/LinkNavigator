import UIKit

public protocol RouteBuilder {
	var matchPath: String { get }

  var build: (LinkNavigatorType, [String: String], DependencyType) -> UIViewController { get }
}
