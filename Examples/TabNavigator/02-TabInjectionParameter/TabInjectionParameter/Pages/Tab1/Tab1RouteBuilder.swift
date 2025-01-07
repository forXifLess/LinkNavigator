import LinkNavigator
import SwiftUI

struct Tab1RouteBuilder {

  @MainActor
  func generate() -> RouteBuilderOf<TabPartialNavigator> {
    let matchPath = "tab1"
    return .init(matchPath: matchPath) { navigator, _, _ -> RouteViewController? in
      WrappingController(matchPath: matchPath) {
        Tab1Page(navigator: navigator)
      }
    }
  }
}
