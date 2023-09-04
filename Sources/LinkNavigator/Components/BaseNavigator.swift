import SwiftUI

// MARK: - BaseNavigator

public struct BaseNavigator {
  let viewController: UINavigationController
}

// MARK: UIViewControllerRepresentable

extension BaseNavigator: UIViewControllerRepresentable {
  public func makeUIViewController(context _: Context) -> UINavigationController {
    viewController
  }

  public func updateUIViewController(_: UINavigationController, context _: Context) { }
}
