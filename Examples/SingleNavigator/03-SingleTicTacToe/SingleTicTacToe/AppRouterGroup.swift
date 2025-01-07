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
      LoginRouteBuilder().generate(),
      NewGameRouteBuilder().generate(),
      GameRouteBuilder().generate(),
    ]
  }
}
