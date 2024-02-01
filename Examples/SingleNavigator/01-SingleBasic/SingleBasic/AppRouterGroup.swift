import LinkNavigator

public typealias RootNavigatorType = LinkNavigatorFindLocationUsable & LinkNavigatorProtocol

// MARK: - AppRouterGroup

struct AppRouterGroup<RootNavigator: RootNavigatorType> {
  init() { }

  var routers: [RouteBuilderOf<RootNavigator>] {
    [
      HomeRouteBuilder.generate(),
      Page1RouteBuilder.generate(),
      Page2RouteBuilder.generate(),
      Page3RouteBuilder.generate(),
      Page4RouteBuilder.generate(),
    ]
  }
}
