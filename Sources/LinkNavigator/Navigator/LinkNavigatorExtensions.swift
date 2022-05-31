import Foundation

extension LinkNavigatorType {
	public func backOrNext(path: String, queryItems: [String: QueryItemConvertable] = [:], target: LinkTarget = .default, animated: Bool = true) {
		isCurrentContain(path: path)
			? back(path: path, target: target, animated: animated)
			: href(paths: [path], queryItems: queryItems, target: target, animated: animated, errorAction: .none)
	}

	public func next(path: String, remotePaths: [String], queryItems: [String: QueryItemConvertable] = [:], target: LinkTarget = .default, animated: Bool = true) {
		href(paths: [path], queryItems: queryItems, target: target, animated: animated, errorAction: .none)
	}

	public func replace(paths: [String], queryItems: [String: QueryItemConvertable] = [:], target: LinkTarget = .default, animated: Bool = true) {
		replace(paths: paths, queryItems: queryItems, animated: animated, errorAction: .none)
	}

	public func replace(path: String, queryItems: [String: QueryItemConvertable] = [:], target: LinkTarget = .default, animated: Bool = true) {
		replace(paths: [path], queryItems: queryItems, animated: animated, errorAction: .none)
	}
}
