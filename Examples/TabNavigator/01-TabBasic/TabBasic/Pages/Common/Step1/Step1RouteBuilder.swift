import LinkNavigator
import SwiftUI

struct Step1RouteBuilder<RootNavigator: RootNavigatorType> {

    static func generate(hidesBottomBarWhenPushed: Bool = false) -> RouteBuilderOf<RootNavigator> {
    var matchPath: String { "step1" }
    return .init(matchPath: matchPath) { navigator, _, _ -> RouteViewController? in
        WrappingController(matchPath: matchPath, hidesBottomBarWhenPushed: hidesBottomBarWhenPushed) {
        Step1Page(navigator: navigator)
      }
    }
  }
}
