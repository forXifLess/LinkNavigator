import Combine
import Foundation
import LinkNavigator

// MARK: - Page3IntentType

protocol Page3IntentType {
  var state: Page3Model.State { get }

  func send(action: Page3Model.ViewAction)
}

// MARK: - Page3Intent

final class Page3Intent: ObservableObject {

  // MARK: Lifecycle

  init(initialState: State, navigator: LinkNavigatorType) {
    state = initialState
    self.navigator = navigator
  }

  // MARK: Internal

  typealias State = Page3Model.State
  typealias ViewAction = Page3Model.ViewAction

  @Published var state = State(message: "")

  let navigator: LinkNavigatorType
  var cancellable: Set<AnyCancellable> = []
}

// MARK: IntentType, Page3IntentType

extension Page3Intent: IntentType, Page3IntentType {
  func mutate(action: Page3Model.ViewAction, viewEffect: (() -> Void)?) {
    switch action {
    case .getPaths:
      state.paths = navigator.currentPaths

    case .onChangeMessage(let message):
      state.message = message

    case .onTapNextWithMessage:
      navigator.next(paths: ["page4"], items: ["page4-message": state.message], isAnimated: true)

    case .onRemovePage1and2:
      navigator.remove(paths: ["page1", "page2"])
      state.paths = navigator.currentPaths

    case .onTapBack:
      navigator.back(isAnimated: true)

    case .onTapClose:
      navigator.close(isAnimated: true) {
        print("modal dismissed!")
        self.navigator.rootReloadLast(isAnimated: false, items: [:])
      }
    }
  }
}
