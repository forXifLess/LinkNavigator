import LinkNavigator
import SwiftUI

// MARK: - AppDependency

struct AppDependency: DependencyType {
  let eventObserver: EventObserver<EventState> = .init(state: .init(currentTabID: .tab2))
  let userManager: UserManager
}

// MARK: - EventState

struct EventState: Equatable {
  var currentTabID: TapID

  enum TapID: Equatable {
    case tab1
    case tab2
    case tab3
  }
}
