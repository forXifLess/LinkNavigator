import SwiftUI
import LinkNavigator

// MARK: - AppDelegate

final class AppDelegate: NSObject {
  let navigator = LinkNavigator(dependency: AppDependency(), builders: AppRouterGroup().routers)
}

// MARK: UIApplicationDelegate

extension AppDelegate: UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
    true
  }
}
