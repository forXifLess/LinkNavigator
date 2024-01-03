import LinkNavigator

public typealias RootNavigatorType = LinkNavigatorProtocol & LinkNavigatorFindLocationUsable

struct AppRouterGroup<RootNavigator: RootNavigatorType> {
  init() { }

  var routers: [RouteBuilderOf<RootNavigator>] {
    [
    ]
  }
}
