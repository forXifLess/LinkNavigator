import LinkNavigator

public typealias RootNavigatorType = LinkNavigatorFindLocationUsable & LinkNavigatorProtocol

// MARK: - AppRouterGroup

struct AppRouterGroup<RootNavigator: RootNavigatorType> {
  init() { }

  var routers: [RouteBuilderOf<RootNavigator>] {
    [
      HomeRouteBuilder.generate(),
      LoginRouteBuilder.generate(),
      NewGameRouteBuilder.generate(),
      GameRouteBuilder.generate(),
    ]
  }
}
