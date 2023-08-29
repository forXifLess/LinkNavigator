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

  func mutate(action: HomeModel.ViewAction, viewEffect _: (() -> Void)?) {
    switch action {
    case .getPaths:
      state.paths = navigator.currentPaths

    case .onTapNext:
      navigator.next(paths: ["page1"], items: [:], isAnimated: true)

    case .onTapPage3:
      navigator.next(paths: ["page1", "page2", "page3"], items: [:], isAnimated: true)

    case .onTapAlert:
      let alertModel = Alert(
        title: "Title",
        message: "message",
        buttons: [.init(title: "OK", style: .default, action: { print("OK tapped") })],
        flagType: .default)
      navigator.alert(target: .default, model: alertModel)

    case .onTapSheet:
      navigator.sheet(paths: ["page1", "page2"], items: [:], isAnimated: true)

    case .onTapFullSheet:
      navigator.fullSheet(paths: ["page1", "page2"], items: [:], isAnimated: true, prefersLargeTitles: true)
    }
  }
}
