import LinkNavigator
import SwiftUI

struct Tab2RouteBuilder {

  @MainActor
  func generate() -> RouteBuilderOf<TabPartialNavigator> {
    let matchPath: String = "tab2"
    return .init(matchPath: matchPath) { navigator, _, _ -> RouteViewController? in
      WrappingController(matchPath: matchPath) {
        Tab2Page(navigator: navigator)
      }
    }
  }
}
