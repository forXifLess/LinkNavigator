import LinkNavigator
import SwiftUI

struct Step3RouteBuilder {

  @MainActor
  func generate() -> RouteBuilderOf<TabPartialNavigator> {
    let matchPath = "step3"
    return .init(matchPath: matchPath) { navigator, _, _ -> RouteViewController? in
      WrappingController(matchPath: matchPath) {
        Step3Page(navigator: navigator)
      }
    }
  }
}
