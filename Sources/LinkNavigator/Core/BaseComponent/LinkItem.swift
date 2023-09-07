import Foundation

// MARK: - LinkItem

/// Represents a link item that contains paths and associated items.
/// It is used to manage the links and state values that are injected into a page.
public struct LinkItem<ItemType> {

  // MARK: Lifecycle

  /// Initializes a LinkItem instance with a given path list and an items parameter.
  ///
  /// - Parameters:
  ///   - pathList: An array of strings representing the path list.
  ///   - items: The items associated with the pathList.
  public init(pathList: [String], items: ItemType) {
    self.pathList = pathList
    self.items = items
  }

  /// Initializes a LinkItem instance with a given path and an items parameter.
  ///
  /// - Parameters:
  ///   - path: A string representing the path.
  ///   - items: The items associated with the path.
  public init(path: String, items: ItemType) {
    pathList = [path]
    self.items = items
  }

  // MARK: Internal

  /// An array of strings representing the path list.
  let pathList: [String]

  /// A parameter containing the items associated with the path or path list.
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
  /// Initializes a LinkItem instance with a given path list and an optional items parameter.
  ///
  /// - Parameters:
  ///   - pathList: An array of strings representing the path list.
  ///   - items: Encoded URLEncodedQuery items. Defaults to an empty string.
  public init(pathList: [String], items: ItemType = "") {
    self.pathList = pathList
    self.items = items
  }

  /// Initializes a LinkItem instance with a given path and an optional items parameter.
  ///
  /// - Parameters:
  ///   - path: A string representing the path.
  ///   - items: Encoded URLEncodedQuery items. Defaults to an empty string.
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
