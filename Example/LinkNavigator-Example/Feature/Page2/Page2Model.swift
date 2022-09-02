import Foundation

enum Page2Model {
  struct State: Equatable {
    var paths: [String] = []
  }

  enum ViewAction: Equatable {
    case getPaths
    case onTapPage3
    case onRemovePage1
    case onTapBack
  }
}
