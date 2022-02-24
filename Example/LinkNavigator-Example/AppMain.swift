import SwiftUI

@main
struct AppMain{
  @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDeletate
}

extension AppMain: App {

  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}
