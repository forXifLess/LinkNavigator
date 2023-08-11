import LinkNavigator
import SwiftUI

// MARK: - Page3RouteBuilder

struct Page3RouteBuilder: RouteBuilder {
  var matchPath: String { "page3" }

  var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
    { navigator, items, _ in
      WrappingController(matchPath: matchPath) {
        Page3View.build(
          intent: Page3Intent(
            initialState: .init(message: items.getValue(key: "page3-message") ?? ""),
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
