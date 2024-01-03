import LinkNavigator
import SwiftUI

struct Tab3RouteBuilder<RootNavigator: RootNavigatorType> {

  static func generate() -> RouteBuilderOf<RootNavigator> {
    var matchPath: String { "tab3" }
    return .init(matchPath: matchPath) { navigator, items, diContainer -> RouteViewController? in
      return WrappingController(matchPath: matchPath) {
        Tab3Page(navigator: navigator)
      }
    }
  }
}
