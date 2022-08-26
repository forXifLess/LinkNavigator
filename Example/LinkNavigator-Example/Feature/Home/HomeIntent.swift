import Combine
import Foundation
import LinkNavigator

// MARK: - HomeIntentType

protocol HomeIntentType {
  var state: HomeModel.State { get }
  var navigator: LinkNavigatorType { get }

  func send(action: HomeModel.ViewAction)
}

// MARK: - HomeIntent

final class HomeIntent: ObservableObject {

  // MARK: Lifecycle

  init(initialState: State, navigator: LinkNavigatorType) {
    state = initialState
    self.navigator = navigator
  }

  // MARK: Internal

  typealias State = HomeModel.State
  typealias ViewAction = HomeModel.ViewAction

  @Published var state: State = .init()
  let navigator: LinkNavigatorType
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
      navigator.fullSheet(paths: ["setting"], items: [:], isAnimated: true)
    case .onTapRouteError:
      break
    case .onTapNewNotification:
      break
    }
  }
}
