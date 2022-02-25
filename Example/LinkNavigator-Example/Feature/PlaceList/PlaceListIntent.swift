import Combine
import Foundation
import LinkNavigator

// MARK: - PlaceListIntentType

protocol PlaceListIntentType {
  var state: PlaceListModel.State { get }
  var enviroment: EnviromentType { get }
  var navigator: LinkNavigatorType { get }

  func send(action: PlaceListModel.ViewAction)
}

// MARK: - PlaceListIntent

final class PlaceListIntent: ObservableObject {

  // MARK: Lifecycle

  init(initialState: State, enviroment: EnviromentType, navigator: LinkNavigatorType) {
    state = initialState
    self.enviroment = enviroment
    self.navigator = navigator
  }

  // MARK: Internal

  typealias State = PlaceListModel.State
  typealias ViewAction = PlaceListModel.ViewAction

  @Published var state: State = .init(places: [])
  let enviroment: EnviromentType
  let navigator: LinkNavigatorType
  var cancellable: Set<AnyCancellable> = []
}

// MARK: IntentType, PlaceListIntentType

extension PlaceListIntent: IntentType, PlaceListIntentType {
  func mutate(action: PlaceListModel.ViewAction, viewEffect: (() -> Void)?) {
    switch action {
    case .getPlaceList:
      (1..<1000)
        .forEach {
          state = state.mutate(places: state.places + [$0])
        }

    case let .onTapPlace(id):
      navigator.href(url: "/place?place_id=\(id)", didOccuredError: .none)

    case .onTapBack:
      navigator.back()
    }
  }
}
