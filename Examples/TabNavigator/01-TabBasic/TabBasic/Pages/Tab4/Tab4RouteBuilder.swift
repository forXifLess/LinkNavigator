import LinkNavigator
import SwiftUI

struct Tab4RouteBuilder {

  @MainActor
  func generate() -> RouteBuilderOf<TabPartialNavigator> {
    let matchPath: String = "tab4"
    return .init(matchPath: matchPath) { navigator, _, _ -> RouteViewController? in
      WrappingController(matchPath: matchPath) {
        Tab4Page(navigator: navigator)
      }
    }
  }
}
