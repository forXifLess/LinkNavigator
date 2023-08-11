import Dependencies
import LinkNavigator
import SwiftUI

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

// MARK: App

extension AppMain: App {

  var body: some Scene {
    WindowGroup {
      navigator
        .launch(paths: ["home"], items: [:], prefersLargeTitles: false)
        .onOpenURL { url in
          print(url.absoluteString)
          // !!!: tca-ex://host/home/page1/page2/page3/page4?page3-message=hello&page4-message=%ED%95%9C%EA%B8%80
          DeepLinkParser.parse(url: url, completeAction: { linkInfo in
            guard let linkInfo else { return }
            navigator.currentPaths.count > 1
              ? navigator.next(paths: [linkInfo.pathList.last ?? ""], items: linkInfo.items, isAnimated: true)
              : navigator.replace(paths: linkInfo.pathList, items: linkInfo.items, isAnimated: true)
          })
        }
        /// - Note:
        ///   If you are using the ignoresSafeArea property to ignore the safe area on an internal screen,
        ///   please add the corresponding code to the part where you first execute the LinkNavigator.
        .ignoresSafeArea()
    }
  }
}
