import ComposableArchitecture
import Dependencies

public struct Page1: ReducerProtocol {

  public struct State: Equatable {
    var rootPath: [String] = []
    var subPath: [String] = []
  }

  public enum Action: Equatable {
    case getRootPath
    case getSubPath
    case onTapPage2
    case onTapRandomBackOrNext
    case onTapRootRandomBackOrNext
    case onTapBack
  }

  public init() {}

  @Dependency(\.sideEffect.page1) var sideEffect

  public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action {
    case .getRootPath:
      state.rootPath = sideEffect.getRootPath()
      return .none

    case .getSubPath:
      state.subPath = sideEffect.getSubPath()
      return .none

    case .onTapPage2:
      sideEffect.routeToPage2()
      return .none

    case .onTapRandomBackOrNext:
      sideEffect.routeToRandomBackOrNext()
      return .none

    case .onTapRootRandomBackOrNext:
      sideEffect.routeToRootRandomBackOrNext()
      return .none

    case .onTapBack:
      sideEffect.routeToBack()
      return .none
    }
  }
}
