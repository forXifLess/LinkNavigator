import LinkNavigator
import SwiftUI

// MARK: - GameRouteBuilder

struct GameRouteBuilder<RootNavigator: RootNavigatorType> {

  static func generate() -> RouteBuilderOf<RootNavigator> {
    var matchPath: String { "game" }
    return .init(matchPath: matchPath) { navigator, items, _ -> RouteViewController? in
      let query: GameInjectionData? = items.decoded()
      return WrappingController(matchPath: matchPath) {
        GameView(navigator: navigator, injectionData: query)
      }
    }
  }
}

// MARK: - GameInjectionData

struct GameInjectionData: Equatable, Codable {
  let gameTitle: String
}
