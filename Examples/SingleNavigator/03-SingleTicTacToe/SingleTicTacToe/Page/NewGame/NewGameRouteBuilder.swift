import LinkNavigator
import SwiftUI

struct NewGameRouteBuilder<RootNavigator: SingleLinkNavigator> {

  @MainActor
  func generate() -> RouteBuilderOf<SingleLinkNavigator> {
    let matchPath = "newGame"
    return .init(matchPath: matchPath) { navigator, _, _ -> RouteViewController? in
      WrappingController(matchPath: matchPath) {
        NewGameView(navigator: navigator)
      }
    }
  }
}
