import ComposableArchitecture

public struct Home: ReducerProtocol {
  public struct State: Equatable {
    var rootPath: [String] = []
    var subPath: [String] = []
  }

  public enum Action: Equatable {
    case getRootPath
    case getSubPath
    case onTapPage1
    case onTapPage2
    case onTapPage3
    case onTapSheet
    case onTapFullSheet
  }

  @Dependency(\.sideEffect.home) var sideEffect

  public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action {
    case .getRootPath:
      state.rootPath = sideEffect.getRootPaths()
      return .none

    case .getSubPath:
      state.subPath = sideEffect.getSubPaths()
      return .none

    case .onTapPage1:
      sideEffect.routeToPage1()
      return .none

    case .onTapPage2:
      sideEffect.routeToPage2()
      return .none

    case .onTapPage3:
      sideEffect.routeToPage3()
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
