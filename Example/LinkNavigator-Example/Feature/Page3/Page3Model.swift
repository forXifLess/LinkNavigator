import SwiftUI

enum Page3Model {
  struct State: Equatable {
    var paths: [String] = []
    @SwiftUI.State var message: String

    static func == (lhs: Page3Model.State, rhs: Page3Model.State) -> Bool {
      lhs.paths == rhs.paths && lhs.message == rhs.message
    }
  }

  enum ViewAction: Equatable {
    case getPaths
    case onTapNextWithMessage
    case onRemovePage1and2
    case onTapBack
    case onTapClose
  }
}
