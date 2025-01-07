import LinkNavigator
import SwiftUI

struct Tab3RouteBuilder {

  @MainActor
  func generate() -> RouteBuilderOf<TabPartialNavigator> {
    let matchPath = "tab3"
    return .init(matchPath: matchPath) { navigator, _, _ -> RouteViewController? in
      WrappingController(matchPath: matchPath) {
        Tab3Page(navigator: navigator)
      }
    }
  }
}
