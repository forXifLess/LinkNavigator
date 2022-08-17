import Combine
import Foundation

// MARK: - NotificationIntentType

protocol NotificationIntentType {
  var state: NotificationModel.State { get }

  func send(action: NotificationModel.ViewAction)
}

// MARK: - NotificationIntent

final class NotificationIntent: ObservableObject {

  // MARK: Lifecycle

  init(initialState: State) {
    state = initialState
  }

  // MARK: Internal

  typealias State = NotificationModel.State
  typealias ViewAction = NotificationModel.ViewAction

  @Published var state: State = .init()
  var cancellable: Set<AnyCancellable> = []
}

// MARK: IntentType, NotificationIntentType

extension NotificationIntent: IntentType, NotificationIntentType {
  func mutate(action: NotificationModel.ViewAction, viewEffect: (() -> Void)?) {
    switch action {
    case .onTapPlaceList:
      break
    case .onTapBack:
      break
    case .onTapCallBackHome:
      break
    }
  }
}
