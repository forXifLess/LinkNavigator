import LinkNavigator

public typealias RootNavigatorType = LinkNavigatorProtocol & LinkNavigatorFindLocationUsable

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
