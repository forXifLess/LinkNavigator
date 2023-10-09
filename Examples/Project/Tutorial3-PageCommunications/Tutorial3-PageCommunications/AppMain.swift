import SwiftUI
import LinkNavigator

@main
struct AppMain: App {

  var appContainer: AppContainer = .generate()

  var body: some Scene {
    WindowGroup {
      LinkNavigationView(
        linkNavigator: appContainer.navigator,
        item: .init(path: AppLink.Path.splash.rawValue),
        prefersLargeTitles: true)
      .ignoresSafeArea()
    }
  }
}
