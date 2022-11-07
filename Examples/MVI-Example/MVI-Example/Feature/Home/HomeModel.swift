import Foundation

enum HomeModel {
  struct State: Equatable {
    var paths: [String] = []
  }

  enum ViewAction: Equatable {
    case getPaths
    case onTapNext
    case onTapPage3
    case onTapAlert
    case onTapSheet
    case onTapFullSheet
  }
}
