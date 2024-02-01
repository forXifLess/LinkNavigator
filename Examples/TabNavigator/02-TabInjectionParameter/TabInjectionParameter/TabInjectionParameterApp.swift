import LinkNavigator
import PageTemplate
import SwiftUI

@main
struct TabInjectionParameterApp: App {
  let tabLinkNavigator = TabLinkNavigator(
    routeBuilderItemList: AppRouterBuilderGroup().routers,
    dependency: AppDependency())

  var body: some Scene {
    WindowGroup {
      TabLinkNavigationView(
        linkNavigator: tabLinkNavigator,
        isHiddenDefaultTabbar: false,
        tabItemList: [
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
        ])
    }
  }
}
