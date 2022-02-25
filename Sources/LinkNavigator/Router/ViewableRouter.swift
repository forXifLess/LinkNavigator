import UIKit

public struct ViewableRouter {
  public let key: String
  public let viewController: UIViewController
  public let matchURL: MatchURL

  public static func emptyView() -> ViewableRouter {
    .init(key: "empty", viewController: UIViewController(), matchURL: .defaultValue())
  }

  public init(key: String, viewController: UIViewController, matchURL: MatchURL) {
    self.key = key
    self.viewController = viewController
    self.matchURL = matchURL
  }
}
