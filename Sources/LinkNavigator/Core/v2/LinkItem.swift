import Foundation

public struct LinkItem: Equatable {
  let paths: [String]
  let items: [String: String]

  public init(paths: [String], items: [String: String] = [:]) {
    self.paths = paths
    self.items = items
  }

  public init(path: String, items: [String: String] = [:]) {
    self.paths = [path]
    self.items = items
  }
}
