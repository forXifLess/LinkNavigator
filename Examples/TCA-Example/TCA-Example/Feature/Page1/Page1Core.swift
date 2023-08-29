import ComposableArchitecture
import Dependencies

public struct Page1: Reducer {

  // MARK: Lifecycle

  public init() { }

  // MARK: Public

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

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
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
        return .run { await $0(.getPaths) }

      case .onTapBack:
        sideEffect.routeToBack()
        return .none
      }
    }
  }

  // MARK: Internal

  @Dependency(\.sideEffect.page1) var sideEffect

}
