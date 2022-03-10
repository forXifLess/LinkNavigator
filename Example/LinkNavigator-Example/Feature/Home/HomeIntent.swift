import Combine
import Foundation
import LinkNavigator

// MARK: - HomeIntentType

protocol HomeIntentType {
  var state: HomeModel.State { get }
  var enviroment: EnviromentType { get }
  var navigator: LinkNavigatorType { get }

  func send(action: HomeModel.ViewAction)
}

// MARK: - HomeIntent

final class HomeIntent: ObservableObject {

  // MARK: Lifecycle

  init(initialState: State, enviroment: EnviromentType, navigator: LinkNavigatorType) {
    state = initialState
    self.enviroment = enviroment
    self.navigator = navigator
  }

  // MARK: Internal

  typealias State = HomeModel.State
  typealias ViewAction = HomeModel.ViewAction

  @Published var state: State = .init()
  let enviroment: EnviromentType
  let navigator: LinkNavigatorType
  var cancellable: Set<AnyCancellable> = []
}

// MARK: IntentType, HomeIntentType

extension HomeIntent: IntentType, HomeIntentType {
  func mutate(action: HomeModel.ViewAction, viewEffect: (() -> Void)?) {
    switch action {
    case .onTapSetting:
      navigator.href(url: "/setting", didOccuredError: .none)
    case .onTapRouteError:
      navigator.href(url: "/noPage") { navigatorType, error in
        navigatorType.alert(model: .init(
          message: error.localizedDescription,
          buttons: [
            .init(title: "Go To Notification", style: .default, action: {
              _ = navigatorType.href(url: "/notification", didOccuredError: .none)
            }),
            .init(title: "ok", style: .cancel, action: {}),
          ],
          flagType: .error))
      }
    case .onTapNewNotification:
      navigator.sheet(url: "link-navigator://notification", animated: true, didOccuredError: .none)
    }
  }
}
