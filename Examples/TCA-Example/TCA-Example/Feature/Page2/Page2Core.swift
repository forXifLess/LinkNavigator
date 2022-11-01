import ComposableArchitecture

public struct Page2: ReducerProtocol {
  public struct State: Equatable {
    var paths: [String] = []
  }

  public enum Action: Equatable {
    case getPaths
    case onTapNext
    case onTapRootPage3
    case onRemovePage1
    case onTapBack
  }

  public init() {}

  @Dependency(\.sideEffect.page2) var sideEffect

  public var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      case .getPaths:
        state.paths = sideEffect.getPaths()
        return .none

      case .onTapNext:
        sideEffect.routeToPage3()
        return .none

      case .onTapRootPage3:
        sideEffect.routeToRootPage3()
        return Effect(value: .getPaths)

      case .onRemovePage1:
        sideEffect.removePage1()
        return Effect(value: .getPaths)

      case .onTapBack:
        sideEffect.routeToBack()
        return .none
      }
    }
  }
}
