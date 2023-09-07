import Foundation
import SwiftUI

// MARK: - LinkNavigationView

public struct LinkNavigationView<ItemValue: EmptyValueType> {
  let linkNavigator: SingleLinkNavigator<ItemValue>
  let item: LinkItem<ItemValue>?

  public init(linkNavigator: SingleLinkNavigator<ItemValue>, item: LinkItem<ItemValue>? = .none) {
    print("AAA inint")
    self.linkNavigator = linkNavigator
    self.item = item
  }
}

// MARK: UIViewControllerRepresentable

extension LinkNavigationView: UIViewControllerRepresentable {
  public static func dismantleUIViewController(_: UINavigationController, coordinator _: ()) {
    print("AAA dismantleUIViewController")
  }

  public func makeUIViewController(context _: Context) -> UINavigationController {
    print("AAA makeUIViewController")
    let vc = UINavigationController()
    vc.setViewControllers(linkNavigator.launch(item: item), animated: false)
    return vc
  }

  public func updateUIViewController(_ uiViewController: UINavigationController, context _: Context) {
    print("AAA updateUIViewController")
    linkNavigator.rootController = uiViewController
  }

}
