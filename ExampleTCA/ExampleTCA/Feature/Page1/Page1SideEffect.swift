import LinkNavigator

public protocol Page1SideEffect {

  var getRootPath: () -> [String] { get }
  var getSubPath: () -> [String] { get }
  var routeToPage2: () -> Void { get }
  var routeToRandomBackOrNext: () -> Void { get }
  var routeToRootRandomBackOrNext: () -> Void { get }
  var routeToBack: () -> Void { get }
}

public struct Page1SideEffectLive {
  let navigator: LinkNavigatorType

  public init(navigator: LinkNavigatorType) {
    self.navigator = navigator
  }
}

extension Page1SideEffectLive: Page1SideEffect {
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

  public var routeToPage2: () -> Void {
    {
      navigator.next(paths: ["page2"], items: [:], isAnimated: true)
    }
  }

  public var routeToRandomBackOrNext: () -> Void {
    {
      navigator.backOrNext(path: Bool.random() ? "home" : "page2", items: [:], isAnimated: true)
    }
  }

  public var routeToRootRandomBackOrNext: () -> Void {
    {
      navigator.rootBackOrNext(path: Bool.random() ? "home" : "page2", items: [:], isAnimated: true)
    }
  }

  public var routeToBack: () -> Void {
    {
      navigator.back(isAnimated: true)
    }
  }


}
