import Foundation

public struct MatchURL {
  public var pathes: [String]
  public var query: [String: QueryItem]

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

  static func getQuery(_ quertItems: [URLQueryItem]?) -> [String: QueryItem] {
    guard let quertItems = quertItems else { return [:] }
    return quertItems.reduce([String: QueryItem](), { curr, next in
      guard let value = next.value else { return curr }
      return curr.merging([next.name: value.serializedQueryItem()]) { $1 }
    })
  }
}

public protocol QueryItemConvertable {
  func serializedQueryItem() -> QueryItem
}

public struct QueryItem: Equatable {

  public let value: String

  public init(value: String) {
    self.value = value
  }

  static var empty: Self {
    .init(value: "")
  }

  public func decodedValue() -> String {
    value.removingPercentEncoding ?? value
  }

  public func decoded<T: Decodable>() -> T? {
    guard let percentDecoded = value.decodedBase64().removingPercentEncoding else { return .none }
    guard let data = percentDecoded.data(using: .utf8) else { return .none }
    return try? JSONDecoder().decode(T.self, from: data)
  }
}

extension String: QueryItemConvertable {
  public func serializedQueryItem() -> QueryItem {
    guard let value = self
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
      return .empty
    }
    return .init(value: value)
  }
}

extension Encodable {
  public func serializedQueryItem() -> QueryItem {
    guard
      let data = self.toJSONData(),
      let encoded = String(data: data, encoding: .utf8),
      let value = encoded
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .encodedBase64()
        .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed  )
    else { return .empty }
    return .init(value: value)
  }

  fileprivate func toJSONData() -> Data? {
    try? JSONEncoder().encode(self)
  }
}

extension String {
  fileprivate func encodedBase64() -> String {
    guard let data = self.data(using: .utf8) else { return self }
    return data.base64EncodedString()
  }

  fileprivate func decodedBase64() -> String {
    guard let data = Data(base64Encoded: self) else { return self }
    return String(data: data, encoding: .utf8) ?? self
  }
}
