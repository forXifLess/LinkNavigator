import LinkNavigator
import SwiftUI

struct GameRouteBuilder<RootNavigator: RootNavigatorType> {

  static func generate() -> RouteBuilderOf<RootNavigator> {
    var matchPath: String { "game" }
    return .init(matchPath: matchPath) { navigator, items, diContainer -> RouteViewController? in
      let query: GameInjectionData? = items.decoded()
      return WrappingController(matchPath: matchPath) {
        GameView(navigator: navigator, injectionData: query)
      }
    }
  }
}

struct GameInjectionData: Equatable, Codable {
  let gameTitle: String
}
