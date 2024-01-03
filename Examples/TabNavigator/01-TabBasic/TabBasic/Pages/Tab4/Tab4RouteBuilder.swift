import SwiftUI
import LinkNavigator

struct Tab4RouteBuilder<RootNavigator: RootNavigatorType> {

  static func generate() -> RouteBuilderOf<RootNavigator> {
    var matchPath: String { "tab4" }
    return .init(matchPath: matchPath) { navigator, items, diContainer -> RouteViewController? in
      return WrappingController(matchPath: matchPath) {
        Tab4Page(navigator: navigator)
      }
    }
  }
}
