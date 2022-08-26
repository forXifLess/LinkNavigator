import LinkNavigator
import UIKit
import SwiftUI

struct SettingRouteBuilder: RouteBuilder {
  var matchPath: String { "setting" }

  var build: (LinkNavigatorType, [String: String], DependencyType) -> UIViewController? {
    { navigator, items, dep in
      WrappingController(matchingKey: matchPath) {
        AnyView(SettingView.build(intent: .init(initialState: .init())))
      }
    }
  }
}
