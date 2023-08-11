import LinkNavigator
import SwiftUI

// MARK: - Page3RouteBuilder

struct Page3RouteBuilder: RouteBuilder {
  var matchPath: String { "page3" }

  var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
    { _, items, _ in
      WrappingController(matchPath: matchPath) {
        Page3View(
          store: .init(
            initialState: Page3.State(message: items.getValue(key: "page3-message") ?? ""),
            reducer: {
              Page3()
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
