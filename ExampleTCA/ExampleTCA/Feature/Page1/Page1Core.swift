import ComposableArchitecture
import Dependencies

public struct Page1: ReducerProtocol {

  public struct State: Equatable {
    var paths: [String] = []
  }

  public enum Action: Equatable {
    case getPaths
    case onTapNext
    case onTapRandomBackOrNext
    case onTapRootRandomBackOrNext
    case onTapBack
  }

  public init() {}

  @Dependency(\.sideEffect.page1) var sideEffect

  public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action {
    case .getPaths:
      state.paths = sideEffect.getPaths()
      return .none

    case .onTapNext:
      sideEffect.routeToPage2()
      return .none

    case .onTapRandomBackOrNext:
      sideEffect.routeToRandomBackOrNext()
      return .none

    case .onTapRootRandomBackOrNext:
      sideEffect.routeToRootRandomBackOrNext()
      return Effect(value: .getPaths)

    case .onTapBack:
      sideEffect.routeToBack()
      return .none
    }
  }
}
