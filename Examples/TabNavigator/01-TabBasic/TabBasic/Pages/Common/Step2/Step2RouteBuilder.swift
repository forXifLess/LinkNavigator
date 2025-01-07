import LinkNavigator
import SwiftUI

struct Step2RouteBuilder {

  @MainActor
  func generate() -> RouteBuilderOf<TabPartialNavigator> {
    let matchPath = "step2"
    return .init(matchPath: matchPath) { navigator, _, _ -> RouteViewController? in
      WrappingController(matchPath: matchPath) {
        Step2Page(navigator: navigator)
      }
    }
  }
}
