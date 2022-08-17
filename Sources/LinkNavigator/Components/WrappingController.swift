import SwiftUI

public final class WrappingController: UIHostingController<AnyView> {

	let matchingKey: String

	public init(
		matchingKey: String,
		@ViewBuilder content: @escaping () -> AnyView) {
		self.matchingKey = matchingKey
		super.init(rootView: content())
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
