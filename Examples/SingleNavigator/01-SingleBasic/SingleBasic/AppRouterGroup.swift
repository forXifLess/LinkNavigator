import LinkNavigator

// MARK: - AppRouterGroup

public struct AppRouterGroup {
  public init() { }
}

extension AppRouterGroup {

  @MainActor
  func routers() -> [RouteBuilderOf<SingleLinkNavigator>] {
    [
      HomeRouteBuilder().generate(),
      Page1RouteBuilder().generate(),
      Page2RouteBuilder().generate(),
      Page3RouteBuilder().generate(),
      Page4RouteBuilder().generate(),
    ]
  }
}
