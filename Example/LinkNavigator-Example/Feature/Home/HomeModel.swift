import Foundation

enum HomeModel {
  struct State: Equatable {
  }

  enum ViewAction: Equatable {
    case onTapSetting
    case onTapRouteError
  }
}
