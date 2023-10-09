import Foundation
import LinkNavigator

final class AppContainer {
  let dependency: AppDependency
  let navigator: SingleLinkNavigator

  private init(dependency: AppDependency, navigator: SingleLinkNavigator) {
    self.dependency = dependency
    self.navigator = navigator
  }

  static func generate() -> Self {
    let dependency = AppDependency()
    return Self.init(
      dependency: dependency,
      navigator: .init(
        routeBuilderItemList: [
          SplashRouteBuilder.generate(),
          LoginRouteBuilder.generate(),
          DashboardRouteBuilder.generate(),
          SettingRouteBuilder.generate(),
        ],
        dependency: dependency))
  }
}


public struct AppDependency: DependencyType {
}
