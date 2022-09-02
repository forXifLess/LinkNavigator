import LinkNavigator
import SwiftUI

struct Page3RouteBuilder: RouteBuilder {
  var matchPath: String { "page3" }

  var build: (LinkNavigatorType, [String: String], DependencyType) -> UIViewController? {
    { navigator, items, dep in
      WrappingController(matchingKey: matchPath) {
        AnyView(Page3.build(
          intent: .init(initialState: .init(), navigator: navigator)))
      }
    }
  }
}
