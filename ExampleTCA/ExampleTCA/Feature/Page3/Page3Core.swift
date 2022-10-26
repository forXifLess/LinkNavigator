import ComposableArchitecture
import Dependencies

public struct Page3: ReducerProtocol {
  public struct State: Equatable {
    var paths: [String] = []

    @BindableState var message = ""
  }

  public enum Action: Equatable, BindableAction {
    case getPaths
    case binding(BindingAction<State>)
    case onTapNextWithMessage
    case onRemovePage1And2
    case onTapBack
    case onTapClose
  }

  public init() {}

  @Dependency(\.sideEffect.page3) var sideEffect

  public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action {
    case .getPaths:
      state.paths = sideEffect.getPaths()
      return .none

    case .binding:
      return .none

    case .onTapNextWithMessage:
      sideEffect.routeToPage4(state.message)
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
    }
  }
}
