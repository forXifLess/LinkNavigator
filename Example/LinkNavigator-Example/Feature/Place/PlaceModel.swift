import Foundation

enum PlaceModel {
  struct State: Equatable {
    let placeID: Int
  }

  enum ViewAction: Equatable {
    case onTapSetting
    case onTapBack
  }
}
