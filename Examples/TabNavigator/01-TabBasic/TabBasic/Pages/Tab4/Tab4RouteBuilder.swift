import LinkNavigator
import SwiftUI

struct Tab4RouteBuilder<RootNavigator: RootNavigatorType> {

  static func generate() -> RouteBuilderOf<RootNavigator> {
    var matchPath: String { "tab4" }
    return .init(matchPath: matchPath) { navigator, _, _ -> RouteViewController? in
      WrappingController(matchPath: matchPath) {
        Tab4Page(navigator: navigator)
      }
    }
  }
}
