import LinkNavigator
import SwiftUI

struct Page1RouteBuilder: RouteBuilder {
  var matchPath: String { "page1" }

  var build: (LinkNavigatorType, [String: String], DependencyType) -> UIViewController? {
    { navigator, items, dep in
      WrappingController(matchingKey: matchPath) {
        AnyView(Page1.build(
          intent: .init(initialState: .init(), navigator: navigator)))
      }
    }
  }
}
