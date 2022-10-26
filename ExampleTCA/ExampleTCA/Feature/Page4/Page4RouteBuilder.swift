import LinkNavigator
import SwiftUI

struct Page4RouteBuilder: RouteBuilder {
  var matchPath: String { "page4" }

  var build: (LinkNavigatorType, [String: String], DependencyType) -> UIViewController? {
    { navigator, items, dep in
      WrappingController(matchingKey: matchPath) {
        AnyView(Page4View(
          store: .init(
            initialState: Page4.State(message: items.getValue(key: "message") ?? ""),
            reducer: Page4())))
      }
    }
  }
}

extension Dictionary where Key == String, Value == String {
  func getValue(key: String) -> String? {
    first(where: { $0.key == key })?.value as? String
  }
}
