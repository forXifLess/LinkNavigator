import Foundation

public struct MatchURL {
  public var pathes: [String]
  public var query: [String: String]

  public static func defaultValue() -> Self {
    self.init(pathes: [], query: [:])
  }

  static func serialzied(url: String) -> Self? {
    guard let components = URLComponents(string: url) else { return .none }

    var compositePaths: [String] {
      let paths = components.path.split(separator: "/").map(String.init)
      guard let host = components.host else {
        return paths
      }
      return [host] + paths
    }

    return .init(
      pathes: getPath(compositePaths),
      query: getQuery(components.queryItems))
  }

  static func getPath(_ path: [String]) -> [String] {
    guard let lastPath = path.last, lastPath.hasPrefix(":") else { return path }
    return path.dropLast()
  }

  static func getFlagment(_ path: [String]) -> String? {
    guard let lastPath = path.last, lastPath.hasPrefix(":") else { return .none }
    return lastPath
  }

  static func getQuery(_ quertItems: [URLQueryItem]?) -> [String: String] {
    guard let quertItems = quertItems else { return [:] }
    return quertItems.reduce([String: String](), { curr, next in
      curr.merging([next.name: next.value ?? ""]) { $1 }
    })
  }
}
