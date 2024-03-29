import Foundation
import UIKit

public class TabRootNavigationController: MatchPathUsable {

  // MARK: Lifecycle

  public init(
    matchPath: String,
    eventSubscriber: LinkNavigatorItemSubscriberProtocol? = nil,
    navigationController: UINavigationController = .init())
  {
    self.matchPath = matchPath
    self.eventSubscriber = eventSubscriber
    self.navigationController = navigationController
  }

  // MARK: Public

  public var matchPath: String
  public var eventSubscriber: LinkNavigatorItemSubscriberProtocol?
  public var navigationController: UINavigationController

}
