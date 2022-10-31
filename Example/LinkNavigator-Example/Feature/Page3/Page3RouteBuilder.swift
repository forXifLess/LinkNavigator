import LinkNavigator
import SwiftUI

struct Page3RouteBuilder: RouteBuilder {
  var matchPath: String { "page3" }

  var build: (LinkNavigatorType, [String: String], DependencyType) -> UIViewController? {
    { navigator, items, dep in
      WrappingController(matchingKey: matchPath) {
        AnyView(Page3View.build(
          intent: Page3Intent(
            initialState: .init(message: items.getValue(key: "inputMessage") ?? ""),
            navigator: navigator)))
      }
    }
  }
}

extension Dictionary where Key == String, Value == String {
  fileprivate func getValue(key: String) -> String? {
    first(where: { $0.key == key })?.value as? String
  }
}
