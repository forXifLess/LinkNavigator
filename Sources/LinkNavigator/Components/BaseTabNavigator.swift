import SwiftUI

// MARK: - BaseViewController

public struct BaseViewController {
  let viewController: UIViewController
}

// MARK: UIViewControllerRepresentable

extension BaseViewController: UIViewControllerRepresentable {
  public func makeUIViewController(context _: Context) -> UIViewController {
    viewController
  }

  public func updateUIViewController(_: UIViewController, context _: Context) { }
}
