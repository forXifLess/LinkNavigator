import Foundation
import URLEncodedForm

// MARK: - LinkItem

/// Represents a link item that contains paths and associated items.
/// It is used to manage the links and state values that are injected into a page.
public struct LinkItem {

  // MARK: Lifecycle

  /// Initializes a LinkItem instance with a given path list and an items parameter.

  /// - Parameters:
  ///   - path: A string representing the path.
  ///   - itemsString: The objects to be injected into pathList are in string format (e.g., queryString, base64EncodedString, etc.).
  ///   - isBase64EncodedItemsString: The 'itemsString' indicates whether it is base64 encoded or not.
  public init(path: String, itemsString: String = "", isBase64EncodedItemsString: Bool = false) {
    pathList = [path]
    encodedItemString = isBase64EncodedItemsString ? itemsString : itemsString.encodedBase64()
  }

  /// - Parameters:
  ///   - pathList: An array of strings representing the path list.
  ///   - itemsString: The objects to be injected into pathList are in string format (e.g., queryString, base64EncodedString, etc.).
  ///   - isBase64EncodedItemsString: The 'itemsString' indicates whether it is base64 encoded or not.
  public init(pathList: [String], itemsString: String = "", isBase64EncodedItemsString: Bool = false) {
    self.pathList = pathList
    encodedItemString = isBase64EncodedItemsString ? itemsString : itemsString.encodedBase64()
  }

  /// - Parameters:
  ///   - path: A string representing the path.
  ///   - items: The object to be injected into the RouteBuilder corresponding to each path .
  public init(path: String, items: Codable?) {
    pathList = [path]
    encodedItemString = items?.encoded() ?? ""
  }

  /// - Parameters:
  ///   - pathList: An array of strings representing the path list.
  ///   - items: The object to be injected into the RouteBuilder corresponding to each path .
  public init(pathList: [String], items: Codable?) {
    self.pathList = pathList
    encodedItemString = items?.encoded() ?? ""
  }

  // MARK: Internal

  /// An array of strings representing the path list.
  public let pathList: [String]

  /// A parameter containing the items associated with the path or path list.
  public let encodedItemString: String
}

extension LinkItem {
  @available(*, deprecated, message: "Please use init(pathList:itemsString:isBase64EncodedItemsString:) instead.")
  public init(pathList: [String], items: String) {
    self.pathList = pathList
    encodedItemString = items
  }

  @available(*, deprecated, message: "Please use init(path:itemsString:isBase64EncodedItemsString:) instead.")
  public init(path: String, items: String) {
    pathList = [path]
    encodedItemString = items
  }
}

// MARK: Equatable

extension LinkItem: Equatable {
  public static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.pathList == rhs.pathList
      && lhs.encodedItemString == rhs.encodedItemString
  }
}

extension String {

  // MARK: Public

  public func decoded<T: Decodable>() -> T? {
    guard !isEmpty else { return .none }
    if let decodedValue = self as? T {
      return decodedValue
    }
    guard let data = Data(base64Encoded: self) else { return .none }
    return (try? JSONDecoder().decode(T.self, from: data)) ?? (try? URLEncodedFormDecoder().decode(T.self, from: data))
  }

  // MARK: Fileprivate

  fileprivate func encodedBase64() -> Self {
    data(using: .utf8)?.base64EncodedString() ?? self
  }
}

extension Encodable {
  public func encoded() -> String {
    guard let data = try? JSONEncoder().encode(self) else { return "" }

    return data.base64EncodedString()
  }
}
