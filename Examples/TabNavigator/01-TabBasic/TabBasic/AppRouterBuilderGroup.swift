import LinkNavigator

public typealias RootNavigatorType = TabLinkNavigatorProtocol & LinkNavigatorFindLocationUsable

struct AppRouterBuilderGroup<RootNavigator: RootNavigatorType> {
  init() { }

  var routers: [RouteBuilderOf<RootNavigator>] {
    [
      Tab1RouteBuilder.generate(),
      Tab2RouteBuilder.generate(),
      Tab3RouteBuilder.generate(),
      Tab4RouteBuilder.generate()
    ]
  }
}
