import Foundation

// MARK: - LinkItem

/// Represents a link item that contains paths and associated items.
/// It is used to manage the links and state values that are injected into a page.
public struct LinkItem<ItemType> {

  // MARK: Lifecycle

  /// Initializes a LinkItem instance with a given path list and an optional items dictionary.
  ///
  /// - Parameters:
  ///   - pathList: An array of strings representing the path list.
  ///   - items: A dictionary containing key-value pairs representing the items. Defaults to an empty dictionary.
  public init(pathList: [String], items: ItemType) {
    self.pathList = pathList
    self.items = items
  }

  /// Initializes a LinkItem instance with a given path and an optional items dictionary.
  ///
  /// - Parameters:
  ///   - path: A string representing the path.
  ///   - items: A dictionary containing key-value pairs representing the items. Defaults to an empty dictionary.
  public init(path: String, items: ItemType) {
    pathList = [path]
    self.items = items
  }

  // MARK: Internal

  /// An array of strings representing the path list.
  let pathList: [String]

  /// A dictionary containing key-value pairs representing the items.
  let items: ItemType

}

// MARK: Equatable

extension LinkItem: Equatable {
  public static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.pathList == rhs.pathList
      && "\(lhs.items)" == "\(rhs.items)"
  }
}

extension LinkItem where ItemType == String {
  /// Initializes a LinkItem instance with a given path list and an optional items dictionary.
  ///
  /// - Parameters:
  ///   - pathList: An array of strings representing the path list.
  ///   - items: Encoded URLEncodedQuery items. Defaults to an empty dictionary.
  public init(pathList: [String], items: ItemType = "") {
    self.pathList = pathList
    self.items = items
  }

  /// Initializes a LinkItem instance with a given path and an optional items dictionary.
  ///
  /// - Parameters:
  ///   - path: A string representing the path.
  ///   - items: Encoded URLEncodedQuery items. Defaults to an empty dictionary.
  public init(path: String, items: ItemType = "") {
    pathList = [path]
    self.items = items
  }
}

extension LinkItem where ItemType == [String: String] {
  /// Initializes a LinkItem instance with a given path list and an optional items dictionary.
  ///
  /// - Parameters:
  ///   - pathList: An array of strings representing the path list.
  ///   - items: A dictionary containing key-value pairs representing the items. Defaults to an empty dictionary.
  public init(pathList: [String], items: ItemType = [:]) {
    self.pathList = pathList
    self.items = items
  }

  /// Initializes a LinkItem instance with a given path and an optional items dictionary.
  ///
  /// - Parameters:
  ///   - path: A string representing the path.
  ///   - items: A dictionary containing key-value pairs representing the items. Defaults to an empty dictionary.
  public init(path: String, items: ItemType = [:]) {
    pathList = [path]
    self.items = items
  }
}
