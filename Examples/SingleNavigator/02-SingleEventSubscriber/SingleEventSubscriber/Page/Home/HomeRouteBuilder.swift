import LinkNavigator
import SwiftUI

struct HomeRouteBuilder<RootNavigator: RootNavigatorType> {

  static func generate() -> RouteBuilderOf<RootNavigator> {
    var matchPath: String { "home" }
    return .init(matchPath: matchPath) { navigator, _, diContainer -> RouteViewController? in
      guard let env: AppDependency = diContainer.resolve() else { return .none }
      return WrappingController(matchPath: matchPath) {
        HomeView(
          navigator: navigator,
          sharedViewModel: env.sharedRootViewModel)
      }
    }
  }
}
