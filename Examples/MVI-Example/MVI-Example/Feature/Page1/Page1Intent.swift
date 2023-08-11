import Combine
import Foundation
import LinkNavigator

// MARK: - Page1IntentType

protocol Page1IntentType {
  var state: Page1Model.State { get }

  func send(action: Page1Model.ViewAction)
}

// MARK: - Page1Intent

final class Page1Intent: ObservableObject {

  // MARK: Lifecycle

  init(initialState: State, navigator: LinkNavigatorType) {
    state = initialState
    self.navigator = navigator
  }

  // MARK: Internal

  typealias State = Page1Model.State
  typealias ViewAction = Page1Model.ViewAction

  @Published var state: State = .init()
  let navigator: LinkNavigatorType
  var cancellable: Set<AnyCancellable> = []
}

// MARK: IntentType, Page1IntentType

extension Page1Intent: IntentType, Page1IntentType {
  func mutate(action: Page1Model.ViewAction, viewEffect: (() -> Void)?) {
    switch action {
    case .getPaths:
      state.paths = navigator.currentPaths

    case .onTapNext:
      navigator.next(paths: ["page2"], items: [:], isAnimated: true)

    case .onTapRandomBackOrNext:
      navigator.backOrNext(path: Bool.random() ? "home" : "page2", items: [:], isAnimated: true)

    case .onTapRootRandomBackOrNext:
      navigator.rootBackOrNext(path: Bool.random() ? "home" : "page2", items: [:], isAnimated: true)

    case .onTapBack:
      navigator.back(isAnimated: true)
    }
  }
}
