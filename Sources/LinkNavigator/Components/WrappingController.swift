import SwiftUI

protocol MatchingKeyUsable {
  var matchingKey: String { get }
}

public final class WrappingController<Content: View>: UIHostingController<Content>, MatchingKeyUsable {

  let matchingKey: String

  public init(
    matchingKey: String,
    @ViewBuilder content: () -> Content)
  {
    self.matchingKey = matchingKey
    super.init(rootView: content())
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
