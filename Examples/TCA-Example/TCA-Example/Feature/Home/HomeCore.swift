import ComposableArchitecture

public struct Home: Reducer {
  public struct State: Equatable {
    var paths: [String] = []
  }

  public enum Action: Equatable {
    case getPaths
    case onTapNext
    case onTapPage3
    case onTapAlert
    case onTapSheet
    case onTapFullSheet
  }

  @Dependency(\.sideEffect.home) var sideEffect

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .getPaths:
        state.paths = sideEffect.getPaths()
        return .none

      case .onTapNext:
        sideEffect.routeToPage1()
        return .none

      case .onTapPage3:
        sideEffect.routeToPage3()
        return .none

      case .onTapAlert:
        sideEffect.showAlert()
        return .none

      case .onTapSheet:
        sideEffect.routeToSheet()
        return .none

      case .onTapFullSheet:
        sideEffect.routeToFullSheet()
        return .none
      }
    }
  }
}
