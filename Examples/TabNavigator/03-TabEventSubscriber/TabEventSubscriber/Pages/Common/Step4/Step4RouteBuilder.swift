import LinkNavigator
import SwiftUI

struct Step4RouteBuilder<RootNavigator: RootNavigatorType> {

  static func generate() -> RouteBuilderOf<RootNavigator> {
    var matchPath: String { "step4" }
    return .init(matchPath: matchPath) { navigator, _, _ -> RouteViewController? in
      WrappingController(matchPath: matchPath) {
        Step4Page(navigator: navigator)
      }
    }
  }
}
