import Foundation
import SwiftUI

/// If you need to update an event between each page, please use the corresponding class.
///
/// -Example:
/// ```swift
/// struct AppDependency: DependencyType {
///  let eventObserver<TabState> = .init(state: .init(tabType: .home)
/// }
///
/// struct TabState: Equatable {
/// let tabType: TabType
///
///   enum TabType: Equatable {
///    case home
///    case search
///    case setting
///   }
/// }
///
/// .init(
///   matchPath: "home",
///   routeBuild: { navigator, _, env in
///     WrappingController(matchPath: "home") {
///    VStack {
///      Spacer()
///      Text("home")
///      Button(action: {
///        env.eventObserver.state.tabType = .search
///      }) {
///        Text("push")
///      }
///      Button(action: {
///        navigator.back(isAnimated: true)
///      }) {
///        Text("back")
///      }
///      Spacer()
///    }
///  }
/// }),
///
/// ```
///

public final class EventObserver<State: Equatable>: ObservableObject {

  // MARK: Lifecycle

  public init(state: State) {
    self.state = state
  }

  // MARK: Public

  @Published public var state: State {
    didSet {
      objectWillChange.send()
    }
  }

}
