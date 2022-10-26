import ComposableArchitecture
import Dependencies

public struct Page4: ReducerProtocol {
  public struct State: Equatable {
    var paths: [String] = []
    var message = ""
  }

  public enum Action: Equatable {
    case getPaths
    case onTapBackToHome
    case onTapBack
    case onTapReset
  }

  public init() {}

  @Dependency(\.sideEffect.page4) var sideEffect

  public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action {
    case .getPaths:
      state.paths = sideEffect.getPaths()
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
