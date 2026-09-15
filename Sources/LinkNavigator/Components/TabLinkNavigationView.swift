import Foundation
import SwiftUI

// MARK: - TabLinkNavigationView

public struct TabLinkNavigationView {
  let linkNavigator: TabLinkNavigator
  let isHiddenDefaultTabbar: Bool
  let tabItemList: [TabItem]
  let isAnimatedForUpdateTabbar: Bool
  let reloadToken: Int

  /// - Parameter reloadToken: Change this to force a rebuild even when `tabItemList` is unchanged.
  ///   Navigation done through `next` / `sheet` / `replace` does not go through `tabItemList`, so a
  ///   caller that means "reset the tabs to this state" cannot rely on the list differing.
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

  /// `launch(tagItemList:)` recreates every tab's navigator and root page, so calling it on each
  /// update — SwiftUI may invoke this whenever the parent body is re-evaluated — rolls the stack
  /// back to `tabItemList`, discarding navigation done through `replace` and friends.
  /// Rebuild only when the routing-relevant values actually change.
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
      // Apply tab bar items without touching the stack (e.g. titles rebuilt after a locale change).
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

  /// Values that decide whether the navigation stack must be rebuilt.
  /// `TabItem.tabItem` (`UITabBarItem`) is excluded because it is typically recreated on every
  /// update, which would make every comparison report a change.
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
