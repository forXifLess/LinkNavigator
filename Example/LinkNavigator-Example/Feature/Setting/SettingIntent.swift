import Combine
import Foundation
import LinkNavigator

// MARK: - SettingIntentType

protocol SettingIntentType {
  var state: SettingModel.State { get }
  var environment: EnvironmentType { get }
  var navigator: LinkNavigatorType { get }

  func send(action: SettingModel.ViewAction)
}

// MARK: - SettingIntent

final class SettingIntent: ObservableObject {

  // MARK: Lifecycle

  init(initialState: State, environment: EnvironmentType, navigator: LinkNavigatorType) {
    state = initialState
    self.environment = environment
    self.navigator = navigator
  }

  // MARK: Internal

  typealias State = SettingModel.State
  typealias ViewAction = SettingModel.ViewAction

  @Published var state: State = .init()
  let environment: EnvironmentType
  let navigator: LinkNavigatorType
  var cancellable: Set<AnyCancellable> = []
}

// MARK: IntentType, SettingIntentType

extension SettingIntent: IntentType, SettingIntentType {
  func mutate(action: SettingModel.ViewAction, viewEffect: (() -> Void)?) {
    switch action {
    case .onTapNotification:
      navigator.href(url: "/notification", target: .root, animated: true, errorAction: .none)
    case .onTapBack:
      navigator.back(animated: false)
    }
  }
}
