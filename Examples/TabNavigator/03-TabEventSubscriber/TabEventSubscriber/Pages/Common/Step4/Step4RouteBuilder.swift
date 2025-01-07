import LinkNavigator
import SwiftUI

struct Step4RouteBuilder {

  @MainActor
  func generate() -> RouteBuilderOf<TabPartialNavigator> {
    let matchPath = "step4"
    return .init(matchPath: matchPath) { navigator, _, _ -> RouteViewController? in
      WrappingController(matchPath: matchPath) {
        Step4Page(navigator: navigator)
      }
    }
  }
}
