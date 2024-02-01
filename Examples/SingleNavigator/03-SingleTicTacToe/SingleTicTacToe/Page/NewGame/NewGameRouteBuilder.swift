import LinkNavigator
import SwiftUI

struct NewGameRouteBuilder<RootNavigator: RootNavigatorType> {

  static func generate() -> RouteBuilderOf<RootNavigator> {
    var matchPath: String { "newGame" }
    return .init(matchPath: matchPath) { navigator, _, _ -> RouteViewController? in
      WrappingController(matchPath: matchPath) {
        NewGameView(navigator: navigator)
      }
    }
  }
}
