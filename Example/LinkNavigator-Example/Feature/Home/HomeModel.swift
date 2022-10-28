import Foundation

enum HomeModel {
  struct State: Equatable {
    var paths: [String] = []
  }

  enum ViewAction: Equatable {
    case getPaths
    case onTapNext
    case onTapPage3
    case onTapSheet
    case onTapFullSheet
  }
}
