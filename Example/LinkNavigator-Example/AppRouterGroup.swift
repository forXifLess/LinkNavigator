import LinkNavigator
import Foundation

struct AppRouterGroup {
  var routers: [RouteBuilder] {
    [
      HomeRouteBuilder()
    ]
  }
}
