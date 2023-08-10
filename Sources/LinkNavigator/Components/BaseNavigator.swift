import SwiftUI

public struct BaseNavigator {
	let viewController: UINavigationController
}

extension BaseNavigator: UIViewControllerRepresentable {
	public func makeUIViewController(context: Context) -> UINavigationController {
    return viewController
	}

	public func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
	}
}
