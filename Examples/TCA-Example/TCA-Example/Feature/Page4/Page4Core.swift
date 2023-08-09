import ComposableArchitecture
import UIKit
import Dependencies

public struct Page4: Reducer {
  public struct State: Equatable {
    var paths: [String] = []
    var message = ""
  }

  public enum Action: Equatable {
    case getPaths
    case onTapDeepLink
    case onTapBackToHome
    case onTapBack
    case onTapReset
  }

  public init() {}

  @Dependency(\.sideEffect.page4) var sideEffect

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .getPaths:
        state.paths = sideEffect.getPaths()
        return .none

      case .onTapDeepLink:
        UIPasteboard.general.string = "tca-ex://host/home/page1/page2/page3/page4?page3-message=world&page4-message=hello" // copy deep link
        sideEffect.openSafari("https://www.google.co.kr/")
        return .none

      case .onTapBackToHome:
        sideEffect.routeToHome()
        return .none

      case .onTapBack:
        sideEffect.routeToBack()
        return .none

      case .onTapReset:
        sideEffect.routeToReset()
        return .none
      }
    }
  }
}
