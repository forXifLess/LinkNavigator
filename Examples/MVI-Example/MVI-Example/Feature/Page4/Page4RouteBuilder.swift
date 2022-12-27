import LinkNavigator
import SwiftUI

struct Page4RouteBuilder: RouteBuilder {
  var matchPath: String { "page4" }

  var build: (LinkNavigatorType, [String: String], DependencyType) -> UIViewController? {
    { navigator, items, dep in
      WrappingController(matchingKey: matchPath) {
        Page4View.build(
          intent: Page4Intent(
            initialState: .init(message: items.getValue(key: "page4-message") ?? ""),
            navigator: navigator))
      }
    }
  }
}

extension Dictionary where Key == String, Value == String {
  fileprivate func getValue(key: String) -> String? {
    first(where: { $0.key == key })?.value as? String
  }
}
