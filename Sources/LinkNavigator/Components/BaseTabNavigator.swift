import SwiftUI

// MARK: - BaseViewController

public struct BaseViewController {
  let viewController: UIViewController
}

// MARK: UIViewControllerRepresentable

extension BaseViewController: UIViewControllerRepresentable {
  public func makeUIViewController(context: Context) -> UIViewController {
    viewController
  }

  public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
  }
}
