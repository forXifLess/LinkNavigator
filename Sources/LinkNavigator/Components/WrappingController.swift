import SwiftUI

public protocol MatchPathUsable {
  var matchPath: String { get }
}

public final class WrappingController<Content: View>: UIHostingController<Content>, MatchPathUsable {

  public let matchPath: String

  public init(
    matchPath: String,
    @ViewBuilder content: () -> Content)
  {
    self.matchPath = matchPath
    super.init(rootView: content())
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
