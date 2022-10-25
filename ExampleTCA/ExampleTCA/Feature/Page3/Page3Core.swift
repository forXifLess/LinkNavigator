import ComposableArchitecture
import Dependencies

public struct Page3: ReducerProtocol {
  public struct State: Equatable {
    var paths: [String] = []
  }

  public enum Action: Equatable {
    case getPaths
    case onTapBackToHome
    case onRemovePage1And2
    case onTapBack
    case onTapClose
    case onTapReset
  }

  public init() {}

  @Dependency(\.sideEffect.page3) var sideEffect

  public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action {
    case .getPaths:
      state.paths = sideEffect.getPaths()
      return .none

    case .onTapBackToHome:
      sideEffect.routeToHome()
      return .none

    case .onRemovePage1And2:
      sideEffect.removePage1And2()
      return Effect(value: .getPaths)

    case .onTapBack:
      sideEffect.routeToBack()
      return .none

    case .onTapClose:
      sideEffect.routeToClose()
      return .none

    case .onTapReset:
      sideEffect.routeToReset()
      return .none
    }
  }
}
