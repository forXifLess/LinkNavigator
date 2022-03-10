import Combine
import Foundation
import LinkNavigator

// MARK: - SettingIntentType

protocol SettingIntentType {
  var state: SettingModel.State { get }
  var enviroment: EnviromentType { get }
  var navigator: LinkNavigatorType { get }

  func send(action: SettingModel.ViewAction)
}

// MARK: - SettingIntent

final class SettingIntent: ObservableObject {

  // MARK: Lifecycle

  init(initialState: State, enviroment: EnviromentType, navigator: LinkNavigatorType) {
    state = initialState
    self.enviroment = enviroment
    self.navigator = navigator
  }

  // MARK: Internal

  typealias State = SettingModel.State
  typealias ViewAction = SettingModel.ViewAction

  @Published var state: State = .init()
  let enviroment: EnviromentType
  let navigator: LinkNavigatorType
  var cancellable: Set<AnyCancellable> = []
}

// MARK: IntentType, SettingIntentType

extension SettingIntent: IntentType, SettingIntentType {
  func mutate(action: SettingModel.ViewAction, viewEffect: (() -> Void)?) {
    switch action {
    case .onTapNotification:
      navigator.href(url: "/notification", animated: true, didOccuredError: .none)
    case .onTapBack:
      navigator.back(animated: false)
    }
  }
}
