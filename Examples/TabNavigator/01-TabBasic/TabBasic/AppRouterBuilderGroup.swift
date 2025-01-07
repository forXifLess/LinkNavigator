import LinkNavigator

// MARK: - AppRouterBuilderGroup

struct AppRouterBuilderGroup {
  init() { }
}

extension AppRouterBuilderGroup {
  @MainActor
  func routers() -> [RouteBuilderOf<TabPartialNavigator>] {
    [
      Tab1RouteBuilder().generate(),
      Tab2RouteBuilder().generate(),
      Tab3RouteBuilder().generate(),
      Tab4RouteBuilder().generate(),
      Step1RouteBuilder().generate(),
      Step2RouteBuilder().generate(),
      Step3RouteBuilder().generate(),
      Step4RouteBuilder().generate(),
    ]
  }
}
