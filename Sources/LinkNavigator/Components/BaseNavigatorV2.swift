import Foundation
import SwiftUI

// MARK: - LinkNavigationView

public struct LinkNavigationView<ItemValue: EmptyValueType> {
  let linkNavigator: SingleLinkNavigator<ItemValue>
  let item: LinkItem<ItemValue>?

  public init(linkNavigator: SingleLinkNavigator<ItemValue>, item: LinkItem<ItemValue>? = .none) {
    self.linkNavigator = linkNavigator
    self.item = item
  }
}

// MARK: UIViewControllerRepresentable

extension LinkNavigationView: UIViewControllerRepresentable {
  
  public func makeUIViewController(context _: Context) -> UINavigationController {
    let vc = UINavigationController()
    vc.setViewControllers(linkNavigator.launch(item: item), animated: false)
    return vc
  }

  public func updateUIViewController(_ uiViewController: UINavigationController, context _: Context) {
    linkNavigator.rootController = uiViewController
  }

}
