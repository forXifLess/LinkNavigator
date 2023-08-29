import SwiftUI

// MARK: - MatchPathUsable

public protocol MatchPathUsable {
  var matchPath: String { get }
}

// MARK: - WrappingController

public final class WrappingController<Content: View>: UIHostingController<Content>, MatchPathUsable {

  // MARK: Lifecycle

  public init(
    matchPath: String,
    @ViewBuilder content: () -> Content)
  {
    self.matchPath = matchPath
    super.init(rootView: content())
    title = matchPath
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Public

  public let matchPath: String

}
