import Foundation

enum Page3Model {
  struct State: Equatable {
    var paths: [String] = []
    var message: String

    init(message: String) {
      self.message = message
    }
  }

  enum ViewAction: Equatable {
    case getPaths
    case onChangeMessage(String)
    case onTapNextWithMessage
    case onRemovePage1and2
    case onTapBack
    case onTapClose
  }
}
