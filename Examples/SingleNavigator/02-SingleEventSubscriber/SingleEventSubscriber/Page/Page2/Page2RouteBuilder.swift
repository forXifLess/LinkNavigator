import LinkNavigator
import SwiftUI

struct Page2RouteBuilder {

  @MainActor
  func generate() -> RouteBuilderOf<SingleLinkNavigator> {
    let matchPath: String = "page2"
    return .init(matchPath: matchPath) { navigator, _, _ -> RouteViewController? in
      let linkSubscriber = Page2LinkSubscriber()
      return WrappingController(
        matchPath: matchPath,
        eventSubscriber: linkSubscriber)
      {
        Page2View(
          navigator: navigator,
          linkSubscriber: linkSubscriber)
      }
    }
  }
}
