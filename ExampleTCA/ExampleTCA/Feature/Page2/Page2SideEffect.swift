import LinkNavigator

public protocol Page2SideEffect {

  var getRootPath: () -> [String] { get }
  var getSubPath: () -> [String] { get }
  var routeToPage3: () -> Void { get }
  var routeToRootPage3: () -> Void { get }
  var removeToPage1: () -> Void { get }
  var routeToBack: () -> Void { get }
}

public struct Page2SideEffectLive {
  let navigator: LinkNavigatorType

  public init(navigator: LinkNavigatorType) {
    self.navigator = navigator
  }
}

extension Page2SideEffectLive: Page2SideEffect {
  public var getRootPath: () -> [String] {
    {
      navigator.rootCurrentPaths
    }
  }

  public var getSubPath: () -> [String] {
    {
      navigator.subCurrentPaths
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

  public var removeToPage1: () -> Void {
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
