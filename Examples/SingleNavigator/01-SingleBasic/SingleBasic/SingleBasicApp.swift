import LinkNavigator
import SwiftUI

@main
struct SingleBasicApp: App {
  let singleNavigator = SingleLinkNavigator(
    routeBuilderItemList: AppRouterGroup().routers(),
    dependency: AppDependency())

  var body: some Scene {
    WindowGroup {
      LinkNavigationView(
        linkNavigator: singleNavigator,
        item: .init(path: "home"))
        .ignoresSafeArea()
    }
  }
}
