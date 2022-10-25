import LinkNavigator

public protocol Page2SideEffect {

  var getPaths: () -> [String] { get }
  var routeToPage3: () -> Void { get }
  var routeToRootPage3: () -> Void { get }
  var removePage1: () -> Void { get }
  var routeToBack: () -> Void { get }
}

public struct Page2SideEffectLive {
  let navigator: LinkNavigatorType

  public init(navigator: LinkNavigatorType) {
    self.navigator = navigator
  }
}

extension Page2SideEffectLive: Page2SideEffect {

  public var getPaths: () -> [String] {
    {
      navigator.currentPaths
    }
  }

  public var routeToPage3: () -> Void {
    {
      navigator.next(paths: ["page3"], items: [:], isAnimated: true)
    }
  }

  public var routeToRootPage3: () -> Void {
    {
      navigator.rootNext(paths: ["page3"], items: [:], isAnimated: true)
    }
  }

  public var removePage1: () -> Void {
    {
      navigator.remove(paths: ["page1"])
    }
  }

  public var routeToBack: () -> Void {
    {
      navigator.back(isAnimated: true)
    }
  }

}
