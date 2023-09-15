import SwiftUI

// MARK: - MatchPathUsable

public protocol MatchPathUsable {
  var matchPath: String { get }
  var eventSubscriber: LinkNavigatorItemSubscriberProtocol? { get }
}

// MARK: - WrappingController

public final class WrappingController<Content: View>: UIHostingController<Content>, MatchPathUsable {

  // MARK: Lifecycle

  public init(
    matchPath: String,
    eventSubscriber: LinkNavigatorItemSubscriberProtocol? = .none,
    @ViewBuilder content: () -> Content)
  {
    self.matchPath = matchPath
    self.eventSubscriber = eventSubscriber
    super.init(rootView: content())
    title = matchPath
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Public

  public let matchPath: String
  public let eventSubscriber: LinkNavigatorItemSubscriberProtocol?

}
