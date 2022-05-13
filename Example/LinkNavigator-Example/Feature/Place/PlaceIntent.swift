import Combine
import Foundation
import LinkNavigator

// MARK: - PlaceIntentType

protocol PlaceIntentType {
  var state: PlaceModel.State { get }
  var environment: EnvironmentType { get }
  var navigator: LinkNavigatorType { get }

  func send(action: PlaceModel.ViewAction)
}

// MARK: - PlaceIntent

final class PlaceIntent: ObservableObject {

  // MARK: Lifecycle

  init(initialState: State, environment: EnvironmentType, navigator: LinkNavigatorType) {
    state = initialState
    self.environment = environment
    self.navigator = navigator
  }

  // MARK: Internal

  typealias State = PlaceModel.State
  typealias ViewAction = PlaceModel.ViewAction

  @Published var state: State = .init(placeID: .zero)
  let environment: EnvironmentType
  let navigator: LinkNavigatorType
  var cancellable: Set<AnyCancellable> = []
}

// MARK: IntentType, PlaceIntentType

extension PlaceIntent: IntentType, PlaceIntentType {
  func mutate(action: PlaceModel.ViewAction, viewEffect: (() -> Void)?) {
    switch action {
    case .onTapSetting:
      navigator.href(url: "/setting", target: .root, animated: true, didOccuredError: .none)
    case .onTapBack:
      navigator.back(path: "notification", animated: true)
//      navigator.back(animated: false)
    }
  }
}
