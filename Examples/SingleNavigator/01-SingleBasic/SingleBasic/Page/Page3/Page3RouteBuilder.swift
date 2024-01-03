import LinkNavigator
import SwiftUI

struct Page3RouteBuilder<RootNavigator: RootNavigatorType> {

  static func generate() -> RouteBuilderOf<RootNavigator> {
    var matchPath: String { "page3" }
    return .init(matchPath: matchPath) { navigator, items, diContainer -> RouteViewController? in
      return WrappingController(matchPath: matchPath) {
        Page3View(navigator: navigator)
      }
    }
  }
}
