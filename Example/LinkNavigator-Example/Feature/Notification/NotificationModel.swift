import Foundation

enum NotificationModel {
  struct State: Equatable {
  }

  enum ViewAction: Equatable {
    case onTapPlaceList
    case onTapBack
  }
}
