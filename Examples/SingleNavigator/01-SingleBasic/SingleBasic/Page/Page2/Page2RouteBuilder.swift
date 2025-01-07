import LinkNavigator
import SwiftUI

struct Page2RouteBuilder {

  @MainActor
  func generate() -> RouteBuilderOf<SingleLinkNavigator> {
    let matchPath = "page2"

    return .init(matchPath: matchPath) { navigator, _, _ -> RouteViewController? in
      WrappingController(matchPath: matchPath) {
        Page2View(navigator: navigator)
      }
    }
  }
}
