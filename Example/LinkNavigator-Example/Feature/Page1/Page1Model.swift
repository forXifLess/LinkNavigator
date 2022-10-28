import Foundation

enum Page1Model {
  struct State: Equatable {
    var paths: [String] = []
  }

  enum ViewAction: Equatable {
    case getPaths
    case onTapNext
    case onTapRandomBackOrNext
    case onTapRootRandomBackOrNext
    case onTapBack
  }
}
