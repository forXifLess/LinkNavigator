import SwiftUI
import Dependencies
import LinkNavigator

// MARK: - AppMain

@main
struct AppMain {

  @Dependency(\.sideEffect) var sideEffect
}

// MARK: App

extension AppMain {
  var navigator: LinkNavigator {
    sideEffect.linkNavigator as! LinkNavigator
  }
}

extension AppMain: App {

  var body: some Scene {
    WindowGroup {
      navigator
        .launch(paths: ["home"], items: [:])
    }
  }
}
