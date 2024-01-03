import LinkNavigator
import SwiftUI

struct Step3RouteBuilder<RootNavigator: RootNavigatorType> {

  static func generate() -> RouteBuilderOf<RootNavigator> {
    var matchPath: String { "step3" }
    return .init(matchPath: matchPath) { navigator, items, diContainer -> RouteViewController? in
      return WrappingController(matchPath: matchPath) {
        Step3Page(navigator: navigator)
      }
    }
  }
}
