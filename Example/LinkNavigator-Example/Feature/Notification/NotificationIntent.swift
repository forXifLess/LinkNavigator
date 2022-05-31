import Combine
import Foundation
import LinkNavigator

// MARK: - NotificationIntentType

protocol NotificationIntentType {
  var state: NotificationModel.State { get }
  var environment: EnvironmentType { get }
  var navigator: LinkNavigatorType { get }

  func send(action: NotificationModel.ViewAction)
}

// MARK: - NotificationIntent

final class NotificationIntent: ObservableObject {

  // MARK: Lifecycle

  init(initialState: State, environment: EnvironmentType, navigator: LinkNavigatorType) {
    state = initialState
    self.environment = environment
    self.navigator = navigator
  }

  // MARK: Internal

  typealias State = NotificationModel.State
  typealias ViewAction = NotificationModel.ViewAction

  @Published var state: State = .init()
  let environment: EnvironmentType
  let navigator: LinkNavigatorType
  var cancellable: Set<AnyCancellable> = []
}

// MARK: IntentType, NotificationIntentType

extension NotificationIntent: IntentType, NotificationIntentType {
  func mutate(action: NotificationModel.ViewAction, viewEffect: (() -> Void)?) {
    switch action {
    case .onTapPlaceList:
      navigator.href(url: "/placeList", target: navigator.isOpenedModal ? .sheet : .root, animated: true, errorAction: { _, error in
        print(error)
      })
    case .onTapBack:
      navigator.isOpenedModal
        ? navigator.back(animated: true)
        : navigator.back(path: "setting", animated: true, isReload: true)

    case .onTapCallBackHome:
      navigator.dismiss(animated: true, didCompletion: { [weak self] in
        self?.navigator.back(path: "home", target: .root, animated: true, callBackItem: [
          "homeKey": .init(value: "Test"),
        ])
      })
    }
  }
}
