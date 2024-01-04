import LinkNavigator
import SwiftUI

struct Step2RouteBuilder<RootNavigator: RootNavigatorType> {

  static func generate() -> RouteBuilderOf<RootNavigator> {
    var matchPath: String { "step2" }
    return .init(matchPath: matchPath) { navigator, items, diContainer -> RouteViewController? in
      let param: Step2InjectionData = items.decoded() ?? .init(message: "")
      return WrappingController(matchPath: matchPath) {
        Step2Page(navigator: navigator, message: param.message)
      }
    }
  }
}

public struct Step2InjectionData: Codable {
  public let message: String

  public init(message: String) {
    self.message = message
  }
}
