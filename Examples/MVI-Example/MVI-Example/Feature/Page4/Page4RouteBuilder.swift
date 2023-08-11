import LinkNavigator
import SwiftUI

// MARK: - Page4RouteBuilder

struct Page4RouteBuilder: RouteBuilder {
  var matchPath: String { "page4" }

  var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
    { navigator, items, _ in
      WrappingController(matchPath: matchPath) {
        Page4View.build(
          intent: Page4Intent(
            initialState: .init(message: items.getValue(key: "page4-message") ?? ""),
            navigator: navigator))
      }
    }
  }
}

extension [String: String] {
  fileprivate func getValue(key: String) -> String? {
    first(where: { $0.key == key })?.value as? String
  }
}
