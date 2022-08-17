import Combine
import Foundation
import LinkNavigator

// MARK: - SettingIntentType

protocol SettingIntentType {
  var state: SettingModel.State { get }

  func send(action: SettingModel.ViewAction)
}

// MARK: - SettingIntent

final class SettingIntent: ObservableObject {

  // MARK: Lifecycle

  init(initialState: State) {
    state = initialState
  }

  // MARK: Internal

  typealias State = SettingModel.State
  typealias ViewAction = SettingModel.ViewAction

  @Published var state: State = .init()
  var cancellable: Set<AnyCancellable> = []
}

// MARK: IntentType, SettingIntentType

extension SettingIntent: IntentType, SettingIntentType {
  func mutate(action: SettingModel.ViewAction, viewEffect: (() -> Void)?) {
    switch action {
    case .onTapNotification:
      break
    case .onTapBack:
      break
    }
  }
}
