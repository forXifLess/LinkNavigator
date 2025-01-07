import LinkNavigator
import SwiftUI

struct Page1RouteBuilder {

  @MainActor
  func generate() -> RouteBuilderOf<SingleLinkNavigator> {
    let matchPath: String = "page1"

    return .init(matchPath: matchPath) { navigator, _, _ -> RouteViewController? in
      WrappingController(matchPath: matchPath) {
        Page1View(navigator: navigator)
      }
    }
  }
}
