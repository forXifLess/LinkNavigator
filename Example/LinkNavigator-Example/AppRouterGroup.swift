import LinkNavigator

struct AppRouterGroup {
  var routers: [RouteBuilder] {
    [
      HomeRouteBuilder(),
      Page1RouteBuilder(),
      Page2RouteBuilder(),
      Page3RouteBuilder(),
    ]
  }
}
