import SwiftUI

// MARK: - BaseNavigator

public struct BaseNavigator {
  let viewController: UINavigationController
}

// MARK: UIViewControllerRepresentable

extension BaseNavigator: UIViewControllerRepresentable {
  public func makeUIViewController(context: Context) -> UINavigationController {
    viewController
  }

  public func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
  }
}
