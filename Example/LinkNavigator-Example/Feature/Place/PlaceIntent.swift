import Combine
import Foundation
import LinkNavigator

// MARK: - PlaceIntentType

protocol PlaceIntentType {
  var state: PlaceModel.State { get }

  func send(action: PlaceModel.ViewAction)
}

// MARK: - PlaceIntent

final class PlaceIntent: ObservableObject {

  // MARK: Lifecycle

  init(initialState: State) {
    state = initialState
  }

  // MARK: Internal

  typealias State = PlaceModel.State
  typealias ViewAction = PlaceModel.ViewAction

  @Published var state: State = .init(placeID: .zero)
  var cancellable: Set<AnyCancellable> = []
}

// MARK: IntentType, PlaceIntentType

extension PlaceIntent: IntentType, PlaceIntentType {
  func mutate(action: PlaceModel.ViewAction, viewEffect: (() -> Void)?) {
    switch action {
    case .onTapSetting:
      break
    case .onTapBack:
      break
    }
  }
}
