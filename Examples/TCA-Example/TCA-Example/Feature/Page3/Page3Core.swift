import ComposableArchitecture
import Dependencies

public struct Page3: Reducer {

  // MARK: Lifecycle

  public init() { }

  // MARK: Public

  public struct State: Equatable {
    var paths: [String] = []

    public init(message: String) {
      self.message = message
    }

    @BindingState var message: String
  }

  public enum Action: Equatable, BindableAction {
    case getPaths
    case binding(BindingAction<State>)
    case onTapNextWithMessage
    case onRemovePage1And2
    case onTapBack
    case onTapClose
  }

  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
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
        return .run { await $0(.getPaths) }

      case .onTapBack:
        sideEffect.routeToBack()
        return .none

      case .onTapClose:
        sideEffect.routeToClose()
        return .none
      }
    }
  }

  // MARK: Internal

  @Dependency(\.sideEffect.page3) var sideEffect

}
