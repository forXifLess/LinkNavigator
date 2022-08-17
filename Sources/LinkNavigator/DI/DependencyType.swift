import Foundation

public protocol DependencyType {
	func resolve<T>() -> T?
}

extension DependencyType {
	public func resolve<T>() -> T? {
		self as? T
	}
}
