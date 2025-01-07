import LinkNavigator
import SwiftUI

struct Step1RouteBuilder {

  @MainActor
  func generate() -> RouteBuilderOf<TabPartialNavigator> {
    let matchPath: String = "step1"
    return .init(matchPath: matchPath) { navigator, _, _ -> RouteViewController? in
      WrappingController(matchPath: matchPath) {
        Step1Page(navigator: navigator)
      }
    }
  }
}
