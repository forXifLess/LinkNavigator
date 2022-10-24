import Dependencies
import Foundation
import LinkNavigator

public struct EmptyDependency: DependencyType {
}

fileprivate var navigator: LinkNavigatorType = LinkNavigator(
  dependency: EmptyDependency(),
  builders: AppRouterGroup().routers)

public struct AppSideEffect: DependencyKey {

  let linkNavigator: LinkNavigatorType
  let home: HomeSideEffect
  let page1: Page1SideEffect
  let page2: Page2SideEffect
  let page3: Page3SideEffect

  public static var liveValue: AppSideEffect {
    return .init(
      linkNavigator: navigator,
      home: HomeSideEffectLive(navigator: navigator),
      page1: Page1SideEffectLive(navigator: navigator),
      page2: Page2SideEffectLive(navigator: navigator),
      page3: Page3SideEffectLive(navigator: navigator))
  }
}

extension DependencyValues {
  var sideEffect: AppSideEffect {
    get { self[AppSideEffect.self] }
    set { self[AppSideEffect.self] = newValue }
  }
}
