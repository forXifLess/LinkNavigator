import LinkNavigator
import UIKit
import SwiftUI

struct HomeRouteBuilder: RouteBuilder {
  var matchPath: String { "home" }

  var build: (LinkNavigatorType, [String: String], DependencyType) -> UIViewController? {
    { navigator, items, dep in
      WrappingController(matchingKey: matchPath) {
        AnyView(HomeView.build(intent: .init(initialState: .init())))
      }
    }
  }
}
