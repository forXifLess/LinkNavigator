import LinkNavigator
import SwiftUI

struct Page3RouteBuilder {

  @MainActor
  func generate() -> RouteBuilderOf<SingleLinkNavigator> {
    let matchPath = "page3"
    return .init(matchPath: matchPath) { navigator, _, _ -> RouteViewController? in
      WrappingController(matchPath: matchPath) {
        Page3View(navigator: navigator)
      }
    }
  }
}
