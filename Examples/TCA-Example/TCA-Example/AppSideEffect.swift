import Dependencies
import Foundation
import LinkNavigator

// MARK: - EmptyDependency

public struct EmptyDependency: DependencyType {
}

fileprivate var navigator: LinkNavigatorType = LinkNavigator(
  dependency: EmptyDependency(),
  builders: AppRouterGroup().routers)

// MARK: - AppSideEffect

public struct AppSideEffect: DependencyKey {

  let linkNavigator: LinkNavigatorType
  let home: HomeSideEffect
  let page1: Page1SideEffect
  let page2: Page2SideEffect
  let page3: Page3SideEffect
  let page4: Page4SideEffect

  public static var liveValue: AppSideEffect {
    .init(
      linkNavigator: navigator,
      home: HomeSideEffectLive(navigator: navigator),
      page1: Page1SideEffectLive(navigator: navigator),
      page2: Page2SideEffectLive(navigator: navigator),
      page3: Page3SideEffectLive(navigator: navigator),
      page4: Page4SideEffectLive(navigator: navigator))
  }
}

extension DependencyValues {
  var sideEffect: AppSideEffect {
    get { self[AppSideEffect.self] }
    set { self[AppSideEffect.self] = newValue }
  }
}
