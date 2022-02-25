import LinkNavigator
import SwiftUI
import UIKit

// MARK: - AppDelegate

final class AppDelegate: NSObject {
  let linkRouter: LinkNavigatorType = {
    let dependency: DependencyType = AppDependency()
    return LinkNavigator(
      enviroment: dependency.appEnviroment,
      routerGroup: dependency.appRouteBuildGroup)
  }()
}

// MARK: UIApplicationDelegate

extension AppDelegate: UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
    true
  }
}
