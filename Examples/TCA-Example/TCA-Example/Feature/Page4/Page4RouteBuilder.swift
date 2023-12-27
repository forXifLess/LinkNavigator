import LinkNavigator
import SwiftUI

// MARK: - Page4RouteBuilder

struct Page4RouteBuilder: RouteBuilder {
  var matchPath: String { "page4" }

  var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
    { _, items, _ in
      WrappingController(matchPath: matchPath) {
        Page4View(
          store: .init(
            initialState: Page4.State(message: items.getValue(key: "page4-message") ?? ""),
            reducer: {
              Page4()
            }))
      }
    }
  }
}

extension [String: String] {
  fileprivate func getValue(key: String) -> String? {
    first(where: { $0.key == key })?.value as? String
  }
}