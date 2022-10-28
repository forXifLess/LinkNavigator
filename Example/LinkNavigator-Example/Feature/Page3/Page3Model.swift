import Foundation

enum Page3Model {
  struct State: Equatable {
    var paths: [String] = []
  }

  enum ViewAction: Equatable {
    case getPaths
    case onTapNextWithMessage(String)
    case onRemovePage1and2
    case onTapBack
    case onTapClose
  }
}
