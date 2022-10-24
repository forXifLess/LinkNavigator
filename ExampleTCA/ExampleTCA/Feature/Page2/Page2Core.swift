import ComposableArchitecture

public struct Page2: ReducerProtocol {
  public struct State: Equatable {
    var rootPath: [String] = []
    var subPath: [String] = []
  }

  public enum Action: Equatable {
    case getRootPath
    case getSubPath
    case onTapPage3
    case onTapRootPage3
    case onRemovePage1
    case onTapBack
  }

  public init() {}

  @Dependency(\.sideEffect.page2) var sideEffect

  public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action {
    case .getRootPath:
      state.rootPath = sideEffect.getRootPath()
      return .none

    case .getSubPath:
      state.subPath = sideEffect.getSubPath()
      return .none

    case .onTapPage3:
      sideEffect.routeToPage3()
      return .none

    case .onTapRootPage3:
      sideEffect.routeToRootPage3()
      return .none

    case .onRemovePage1:
      return .concatenate(
        .init(value: .getRootPath),
        .init(value: .getSubPath)
      )

    case .onTapBack:
      sideEffect.routeToBack()
      return .none
    }
  }
}
