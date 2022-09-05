import Foundation

enum HomeModel {
  struct State: Equatable {
    var paths: [String] = []
  }

  enum ViewAction: Equatable {
    case getPaths
    case onTapPage1
    case onTapPage3
    case onTapSheet
    case onTapFullSheet
  }
}
