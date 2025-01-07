import LinkNavigator
import SwiftUI

struct HomeRouteBuilder {

  @MainActor
  func generate() -> RouteBuilderOf<SingleLinkNavigator> {
    let matchPath = "home"
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
