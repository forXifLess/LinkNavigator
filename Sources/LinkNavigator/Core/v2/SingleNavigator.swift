import UIKit

public final class SingleNavigator {

  public let linkPath: String
  public let rootNavigator: Navigator
  public let routeBuilderList: [RouteBuilderOf<SingleNavigator>]
  public let dependency: DependencyType

  private var subNavigator: Navigator?

  public init(
    linkPath: String,
    rootNavigator: Navigator,
    routeBuilderList: [RouteBuilderOf<SingleNavigator>],
    dependency: DependencyType)
  {
    self.linkPath = linkPath
    self.rootNavigator = rootNavigator
    self.routeBuilderList = routeBuilderList
    self.dependency = dependency
  }
}

extension SingleNavigator {

  public func lunch() -> BaseNavigator {
    rootNavigator.replace(
      rootNavigator: self,
      item: rootNavigator.initialLinkItem,
      isAnimated: false,
      routeBuilderList: routeBuilderList,
      dependency: dependency)

    return .init(viewController: rootNavigator.controller)
  }

  public func push(item: LinkItem, isAnimated: Bool) {
    rootNavigator.push(
      rootNavigator: self,
      item: item,
      isAnimated: isAnimated,
      routeBuilderList: routeBuilderList,
      dependency: dependency)
  }
}
