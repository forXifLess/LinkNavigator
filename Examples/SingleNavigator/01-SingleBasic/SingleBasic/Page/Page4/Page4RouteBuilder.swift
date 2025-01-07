import LinkNavigator
import SwiftUI

struct Page4RouteBuilder{

  @MainActor
  func generate() -> RouteBuilderOf<SingleLinkNavigator> {
    let matchPath: String = "page4"

    return .init(matchPath: matchPath) { navigator, _, _ -> RouteViewController? in
      WrappingController(matchPath: matchPath) {
        Page4View(navigator: navigator)
      }
    }
  }
}
