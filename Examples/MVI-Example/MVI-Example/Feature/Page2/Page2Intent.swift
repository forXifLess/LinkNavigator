import Combine
import Foundation
import LinkNavigator

// MARK: - Page2IntentType

protocol Page2IntentType {
  var state: Page2Model.State { get }

  func send(action: Page2Model.ViewAction)
}

// MARK: - Page2Intent

final class Page2Intent: ObservableObject {

  // MARK: Lifecycle

  init(initialState: State, navigator: LinkNavigatorType) {
    state = initialState
    self.navigator = navigator
  }

  // MARK: Internal

  typealias State = Page2Model.State
  typealias ViewAction = Page2Model.ViewAction

  @Published var state: State = .init()
  let navigator: LinkNavigatorType
  var cancellable: Set<AnyCancellable> = []
}

// MARK: IntentType, Page2IntentType

extension Page2Intent: IntentType, Page2IntentType {
  func mutate(action: Page2Model.ViewAction, viewEffect _: (() -> Void)?) {
    switch action {
    case .getPaths:
      state.paths = navigator.currentPaths

    case .onTapNext:
      navigator.next(paths: ["page3"], items: [:], isAnimated: true)

    case .onTapRootPage3:
      navigator.rootNext(paths: ["page3"], items: [:], isAnimated: true)

    case .onRemovePage1:
      navigator.remove(paths: ["page1"])
      state.paths = navigator.currentPaths

    case .onTapBack:
      navigator.back(isAnimated: true)
    }
  }
}
