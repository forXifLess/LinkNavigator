import LinkNavigator
import SwiftUI

struct Page2RouteBuilder: RouteBuilder {
  var matchPath: String { "page2" }

  var build: (LinkNavigatorType, [String: String], DependencyType) -> UIViewController? {
    { navigator, items, dep in
      WrappingController(matchingKey: matchPath) {
        AnyView(Page2.build(
          intent: .init(initialState: .init(), navigator: navigator)))
      }
    }
  }
}
