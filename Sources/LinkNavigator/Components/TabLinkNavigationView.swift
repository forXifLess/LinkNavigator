import Foundation
import SwiftUI

// MARK: - TabLinkNavigationView

public struct TabLinkNavigationView<ItemValue: EmptyValueType> {
  let linkNavigator: TabLinkNavigator<ItemValue>
  let setTabTagList: [TabItem<ItemValue>]

  public init(linkNavigator: TabLinkNavigator<ItemValue>, setTabTagList: [TabItem<ItemValue>]) {
    self.linkNavigator = linkNavigator
    self.setTabTagList = setTabTagList
  }
}

// MARK: UIViewControllerRepresentable

extension TabLinkNavigationView: UIViewControllerRepresentable {
  public func makeUIViewController(context _: Context) -> UITabBarController {
    let vc = UITabBarController()
    vc.setViewControllers(linkNavigator.launch(tagItemList: setTabTagList), animated: false)
    vc.tabBar.isHidden = true
    return vc
  }

  public func updateUIViewController(_ uiViewController: UITabBarController, context _: Context) {
    linkNavigator.mainController = uiViewController
  }
}
