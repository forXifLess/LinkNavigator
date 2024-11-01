import LinkNavigator
import SwiftUI

@main
struct SingleEventSubscriberApp: App {
  let singleNavigator = SingleLinkNavigator(
    routeBuilderItemList: AppRouterGroup().routers,
    dependency: AppDependency(sharedRootViewModel: .init()))

  var body: some Scene {
    WindowGroup {
      LinkNavigationView(
        linkNavigator: singleNavigator,
        item: .init(path: "home"))
        .ignoresSafeArea()
        .onOpenURL { url in
          DeepLinkParser.parse(url: url) { linkItem in
            guard let linkItem else { return }
            singleNavigator.getCurrentPaths().isEmpty
              ? singleNavigator.next(linkItem: .init(path: "home"), isAnimated: true)
              : singleNavigator.replace(linkItem: linkItem, isAnimated: true)
          }
        }
    }
  }
}
