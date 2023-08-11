import Foundation

public struct TagItem: Equatable {
  let tagList: [String]
  let itemList: [String: String]

  public init(tagList: [String], itemList: [String: String] = [:]) {
    self.tagList = tagList
    self.itemList = itemList
  }
}
