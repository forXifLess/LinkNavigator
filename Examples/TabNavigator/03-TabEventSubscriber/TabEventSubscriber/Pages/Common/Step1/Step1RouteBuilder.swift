import LinkNavigator
import SwiftUI

struct Step1RouteBuilder<RootNavigator: RootNavigatorType> {

  static func generate() -> RouteBuilderOf<RootNavigator> {
    var matchPath: String { "step1" }
    return .init(matchPath: matchPath) { navigator, _, _ -> RouteViewController? in
      WrappingController(matchPath: matchPath) {
        Step1Page(navigator: navigator)
      }
    }
  }
}
