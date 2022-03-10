import Combine
import Foundation
import LinkNavigator

// MARK: - NotificationIntentType

protocol NotificationIntentType {
  var state: NotificationModel.State { get }
  var enviroment: EnviromentType { get }
  var navigator: LinkNavigatorType { get }

  func send(action: NotificationModel.ViewAction)
}

// MARK: - NotificationIntent

final class NotificationIntent: ObservableObject {

  // MARK: Lifecycle

  init(initialState: State, enviroment: EnviromentType, navigator: LinkNavigatorType) {
    state = initialState
    self.enviroment = enviroment
    self.navigator = navigator
  }

  // MARK: Internal

  typealias State = NotificationModel.State
  typealias ViewAction = NotificationModel.ViewAction

  @Published var state: State = .init()
  let enviroment: EnviromentType
  let navigator: LinkNavigatorType
  var cancellable: Set<AnyCancellable> = []
}

// MARK: IntentType, NotificationIntentType

extension NotificationIntent: IntentType, NotificationIntentType {
  func mutate(action: NotificationModel.ViewAction, viewEffect: (() -> Void)?) {
    switch action {
    case .onTapPlaceList:
      navigator.href(url: "/placeList", didOccuredError: .none)
    case .onTapBack:
      navigator.back(animated: true)
    }
  }
}
