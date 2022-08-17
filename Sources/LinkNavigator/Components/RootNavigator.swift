import SwiftUI

public struct RootNavigator {
	let viewController: UINavigationController
}

extension RootNavigator: UIViewControllerRepresentable {
	public func makeUIViewController(context: Context) -> UINavigationController {
		viewController
	}

	public func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
	}
}
