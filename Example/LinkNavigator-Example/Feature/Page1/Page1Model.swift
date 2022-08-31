import Foundation

enum Page1Model {
  struct State: Equatable {
    var paths: [String] = []
  }

  enum ViewAction: Equatable {
    case getPaths
    case onTapPage2
    case onTapRandomBackOrNext
    case onTapBack
  }
}
