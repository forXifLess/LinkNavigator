import Combine
import Foundation
import LinkNavigator

// MARK: - PlaceIntentType

protocol PlaceIntentType {
  var state: PlaceModel.State { get }
  var enviroment: EnviromentType { get }
  var navigator: LinkNavigatorType { get }

  func send(action: PlaceModel.ViewAction)
}

// MARK: - PlaceIntent

final class PlaceIntent: ObservableObject {

  // MARK: Lifecycle

  init(initialState: State, enviroment: EnviromentType, navigator: LinkNavigatorType) {
    state = initialState
    self.enviroment = enviroment
    self.navigator = navigator
  }

  // MARK: Internal

  typealias State = PlaceModel.State
  typealias ViewAction = PlaceModel.ViewAction

  @Published var state: State = .init(placeID: .zero)
  let enviroment: EnviromentType
  let navigator: LinkNavigatorType
  var cancellable: Set<AnyCancellable> = []
}

// MARK: IntentType, PlaceIntentType

extension PlaceIntent: IntentType, PlaceIntentType {
  func mutate(action: PlaceModel.ViewAction, viewEffect: (() -> Void)?) {
    switch action {
    case .onTapSetting:
      navigator.href(url: "/setting", didOccuredError: .none)
    case .onTapBack:
      navigator.back()
    }
  }
}
