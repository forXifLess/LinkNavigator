import Foundation

enum SettingModel {
  struct State: Equatable {
  }

  enum ViewAction: Equatable {
    case onTapNotification
    case onTapBack
  }
}
