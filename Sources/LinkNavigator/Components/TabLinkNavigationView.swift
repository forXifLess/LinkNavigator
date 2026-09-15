import Foundation
import SwiftUI

// MARK: - TabLinkNavigationView

public struct TabLinkNavigationView {
  let linkNavigator: TabLinkNavigator
  let isHiddenDefaultTabbar: Bool
  let tabItemList: [TabItem]
  let isAnimatedForUpdateTabbar: Bool
  let reloadToken: Int

  public init(
    linkNavigator: TabLinkNavigator,
    isHiddenDefaultTabbar: Bool,
    tabItemList: [TabItem],
    isAnimatedForUpdateTabbar: Bool = false,
    reloadToken: Int = .zero)
  {
    self.linkNavigator = linkNavigator
    self.isHiddenDefaultTabbar = isHiddenDefaultTabbar
    self.tabItemList = tabItemList
    self.isAnimatedForUpdateTabbar = isAnimatedForUpdateTabbar
    self.reloadToken = reloadToken
  }
}

// MARK: UIViewControllerRepresentable

extension TabLinkNavigationView: UIViewControllerRepresentable {
  public func makeCoordinator() -> Coordinator {
    Coordinator()
  }

  public func makeUIViewController(context _: Context) -> UITabBarController {
    UITabBarController()
  }

  public func updateUIViewController(_ uiViewController: UITabBarController, context: Context) {
    let routeSignature = tabItemList.map(RouteSignature.init)
    let isChangedRoute = context.coordinator.appliedRouteSignature != routeSignature
      || context.coordinator.appliedReloadToken != reloadToken

    if isChangedRoute {
      context.coordinator.appliedRouteSignature = routeSignature
      context.coordinator.appliedReloadToken = reloadToken
      uiViewController.setViewControllers(
        linkNavigator.launch(tagItemList: tabItemList),
        animated: isAnimatedForUpdateTabbar)
    } else {
      zip(uiViewController.viewControllers ?? [], tabItemList).forEach { controller, item in
        controller.tabBarItem = item.tabItem
      }
    }

    if uiViewController.tabBar.isHidden != isHiddenDefaultTabbar {
      uiViewController.tabBar.isHidden = isHiddenDefaultTabbar
    }

    linkNavigator.mainController = uiViewController
  }
}

// MARK: TabLinkNavigationView.Coordinator

extension TabLinkNavigationView {
  public final class Coordinator {
    var appliedRouteSignature: [RouteSignature] = []
    var appliedReloadToken: Int?
  }

  struct RouteSignature: Equatable {

    // MARK: Lifecycle

    init(_ tabItem: TabItem) {
      tag = tabItem.tag
      linkItem = tabItem.linkItem
      prefersLargeTitles = tabItem.prefersLargeTitles
    }

    // MARK: Internal

    let tag: Int
    let linkItem: LinkItem
    let prefersLargeTitles: Bool
  }
}
