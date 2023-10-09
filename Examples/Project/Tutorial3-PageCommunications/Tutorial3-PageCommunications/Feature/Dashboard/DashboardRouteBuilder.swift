import Foundation
import LinkNavigator

struct DashboardRouteBuilder<RootNavigator: SingleLinkNavigator> {
  static func generate() -> RouteBuilderOf<RootNavigator> {
    let matchPath = AppLink.Path.dashboard.rawValue

    return .init(matchPath: matchPath) { navigator, item, dependency -> RouteViewController? in

      let auth: AuthenticationModel = item.decoded() ?? .init()
      let viewModel = DashboardViewModel(auth: auth)

      return WrappingController(matchPath: matchPath, eventSubscriber: viewModel) {
        DashboardPage(
          viewModel: viewModel,
          linkNavigator: navigator)
      }
    }
  }
}
