import Combine
import LinkNavigator
import UIKit

// MARK: - Page4IntentType

protocol Page4IntentType {
  var state: Page4Model.State { get }

  func send(action: Page4Model.ViewAction)
}

// MARK: - Page4Intent

final class Page4Intent: ObservableObject {

  // MARK: Lifecycle

  init(initialState: State, navigator: LinkNavigatorType) {
    state = initialState
    self.navigator = navigator
  }

  // MARK: Internal

  typealias State = Page4Model.State
  typealias ViewAction = Page4Model.ViewAction

  @Published var state: State = .init(message: "")

  let navigator: LinkNavigatorType
  var cancellable: Set<AnyCancellable> = []
}

// MARK: IntentType, Page4IntentType

extension Page4Intent: IntentType, Page4IntentType {
  func mutate(action: Page4Model.ViewAction, viewEffect _: (() -> Void)?) {
    switch action {
    case .getPaths:
      state.paths = navigator.currentPaths

    case .onTapDeepLink:
      guard let url = URL(string: "https://www.google.co.kr/"), UIApplication.shared.canOpenURL(url) else { return }
      UIPasteboard.general
        .string = "mvi-ex://host/home/page1/page2/page3/page4?page3-message=world&page4-message=hello" // copy deep link
      UIApplication.shared.open(url, options: [:], completionHandler: .none)

    case .onTapBackToHome:
      navigator.backOrNext(path: "home", items: [:], isAnimated: true)

    case .onTapBack:
      navigator.back(isAnimated: true)

    case .onTapReset:
      navigator.replace(paths: ["home"], items: [:], isAnimated: true)
    }
  }
}
