import LinkNavigator
import SwiftUI

// MARK: - Step2RouteBuilder

struct Step2RouteBuilder {

  @MainActor
  func generate() -> RouteBuilderOf<TabPartialNavigator> {
    let matchPath: String = "step2"
    return .init(matchPath: matchPath) { navigator, items, _ -> RouteViewController? in
      let param: Step2InjectionData = items.decoded() ?? .init(message: "")

      return WrappingController(matchPath: matchPath) {
        Step2Page(navigator: navigator, injectionData: param)
      }
    }
  }
}

// MARK: - Step2InjectionData

public struct Step2InjectionData: Codable {
  public let message: String

  public init(message: String) {
    self.message = message
  }
}
