import Combine
import Foundation

// MARK: - HomeIntentType

protocol HomeIntentType {
  var state: HomeModel.State { get }

  func send(action: HomeModel.ViewAction)
}

// MARK: - HomeIntent

final class HomeIntent: ObservableObject {

  // MARK: Lifecycle

  init(initialState: State) {
    state = initialState
  }

  // MARK: Internal

  typealias State = HomeModel.State
  typealias ViewAction = HomeModel.ViewAction

  @Published var state: State = .init()
  var cancellable: Set<AnyCancellable> = []
}

// MARK: IntentType, HomeIntentType

extension HomeIntent: IntentType, HomeIntentType {
  func receiveCallback(item: String) {
    print(item)
  }

  func mutate(action: HomeModel.ViewAction, viewEffect: (() -> Void)?) {
    switch action {
    case .onTapSetting:
      break
    case .onTapRouteError:
      break
    case .onTapNewNotification:
      break
    }
  }
}
