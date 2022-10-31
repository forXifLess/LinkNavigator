import SwiftUI
import LinkNavigator

// MARK: - AppMain

@main
struct AppMain {
  @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
}

// MARK: App

extension AppMain {
  var navigator: LinkNavigator {
    appDelegate.navigator
  }
}

extension AppMain: App {

  var body: some Scene {
    WindowGroup {
      navigator
        .launch(paths: ["home"], items: [:])
        .onOpenURL { url in
          print(url.absoluteString)
          /// Note: link-navigator-ex://host/home/page1/page2/page3/page4?inputMessage=hello&message=%ED%95%9C%EA%B8%80
          DeepLinkParser.parse(url: url, completeAction: { linkInfo in
            guard let linkInfo else { return }
            navigator.replace(paths: linkInfo.pathList, items: linkInfo.items, isAnimated: true)
//            navigator.currentPaths.count > 1
//              ? navigator.next(paths: [linkInfo.pathList.last ?? ""], items: linkInfo.items, isAnimated: true)
//              : navigator.replace(paths: linkInfo.pathList, items: linkInfo.items, isAnimated: true)
          })
        }
    }
  }
}
