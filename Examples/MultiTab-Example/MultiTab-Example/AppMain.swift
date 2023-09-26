import LinkNavigator
import SwiftUI

// MARK: - AppMain

@main
struct AppMain {
  @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
  @StateObject var userManager: UserManager = .init()
}

// MARK: App

extension AppMain {
  var tabNavigator: TabLinkNavigator<String> {
    NavigationBuilder().tabLinkNavigator(.init(userManager: userManager))
  }

  var singleNavigator: SingleLinkNavigator<String> {
    NavigationBuilder().singleLinkNavigator(.init(userManager: userManager))
  }
}

// MARK: App

extension AppMain: App {

  var body: some Scene {
    WindowGroup {
      switch userManager.isLogin {
      case true:
        tabNavigator
          .launch()
      case false:
        singleNavigator
          .launch()
      }
    }
  }
}
