import LinkNavigator
import PageTemplate
import SwiftUI

// MARK: - TabEventSubscriberApp

@main
struct TabEventSubscriberApp: App {
  let tabLinkNavigator = TabLinkNavigator(
    routeBuilderItemList: AppRouterBuilderGroup().routers,
    dependency: AppDependency())

  let tabList: [TabItem] = [
    .init(
      tag: .zero,
      tabItem: .init(
        title: "tab1",
        image: UIImage(systemName: "house"),
        selectedImage: UIImage(systemName: "house.fill")),
      linkItem: .init(path: "tab1")),
    .init(
      tag: 1,
      tabItem: .init(
        title: "tab2",
        image: UIImage(systemName: "folder"),
        selectedImage: UIImage(systemName: "folder.fill")),
      linkItem: .init(path: "tab2")),
    .init(
      tag: 2,
      tabItem: .init(
        title: "tab3",
        image: UIImage(systemName: "heart"),
        selectedImage: UIImage(systemName: "heart.fill")),
      linkItem: .init(path: "tab3")),
    .init(
      tag: 3,
      tabItem: .init(
        title: "tab4",
        image: UIImage(systemName: "person"),
        selectedImage: UIImage(systemName: "person.fill")),
      linkItem: .init(path: "tab4")),
  ]

  var body: some Scene {
    WindowGroup {
      TabLinkNavigationView(
        linkNavigator: tabLinkNavigator,
        isHiddenDefaultTabbar: false,
        tabItemList: tabList)
        .onOpenURL { url in
          /// You can test deep links by setting the URL Scheme to "tab-e-s".
          /// Example:
          /// tab-e-s://navigation/tab2/step1/step2?message=opened+by+deep+link

          guard
            let tabPath = getTabPathByDeeplink(url: url),
            let linkItem = getLinkItemByDeepLink(url: url),
            let targetTab = tabLinkNavigator.targetPartialNavigator(tabPath: tabPath)
          else { return }

          tabLinkNavigator.moveTab(targetPath: tabPath)
          targetTab.replace(linkItem: linkItem, isAnimated: true)
        }
    }
  }
}

extension TabEventSubscriberApp {
  private func getTabPathByDeeplink(url: URL) -> String? {
    let components = URLComponents(string: url.absoluteString)
    return components?.path.split(separator: "/").map(String.init).first
  }

  private func getLinkItemByDeepLink(url: URL) -> LinkItem? {
    let components = URLComponents(string: url.absoluteString)
    guard let paths = components?.path.split(separator: "/").map(String.init) else { return .none }

    return .init(pathList: paths, itemsString: components?.query ?? "")
  }
}
