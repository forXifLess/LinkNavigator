import Foundation
import SwiftUI

// MARK: - TabLinkNavigationView

public struct TabLinkNavigationView {
  let linkNavigator: TabLinkNavigator
  let isHiddenDefaultTabbar: Bool
  let tabItemList: [TabItem]
  let isAnimatedForUpdateTabbar: Bool

  public init(
    linkNavigator: TabLinkNavigator,
    isHiddenDefaultTabbar: Bool,
    tabItemList: [TabItem],
    isAnimatedForUpdateTabbar: Bool = false)
  {
    self.linkNavigator = linkNavigator
    self.isHiddenDefaultTabbar = isHiddenDefaultTabbar
    self.tabItemList = tabItemList
    self.isAnimatedForUpdateTabbar = isAnimatedForUpdateTabbar
  }
}

// MARK: UIViewControllerRepresentable

extension TabLinkNavigationView: UIViewControllerRepresentable {
  public func makeUIViewController(context _: Context) -> UITabBarController {
    UITabBarController()
  }

  public func updateUIViewController(_ uiViewController: UITabBarController, context _: Context) {
    uiViewController.setViewControllers(linkNavigator.launch(tagItemList: tabItemList), animated: isAnimatedForUpdateTabbar)
    uiViewController.tabBar.isHidden = isHiddenDefaultTabbar
    linkNavigator.mainController = uiViewController
  }
}
