import ComposableArchitecture
import Dependencies

public struct Page3: ReducerProtocol {
  public struct State: Equatable {
    var rootPath: [String] = []
    var subPath: [String] = []
  }

  public enum Action: Equatable {
    case getRootPath
    case getSubPath
    case onTapBackOrNext
    case onRemovePage1and2
    case onTapBack
    case onTapClose
    case onTapReset
  }

  public init() {}

  @Dependency(\.sideEffect.page3) var sideEffect

  public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action {
    case .getRootPath:
      state.rootPath = sideEffect.getRootPath()
      return .none

    case .getSubPath:
      state.subPath = sideEffect.getSubPath()
      return .none

    case .onTapBackOrNext:
      sideEffect.routeToHome()
      return .none

    case .onRemovePage1and2:
      sideEffect.deleteToPage1And2()
      return .none

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
