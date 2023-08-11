import LinkNavigator

// MARK: - Page1SideEffect

public protocol Page1SideEffect {

  var getPaths: () -> [String] { get }
  var routeToPage2: () -> Void { get }
  var routeToRandomBackOrNext: () -> Void { get }
  var routeToRootRandomBackOrNext: () -> Void { get }
  var routeToBack: () -> Void { get }
}

// MARK: - Page1SideEffectLive

public struct Page1SideEffectLive {
  let navigator: LinkNavigatorType

  public init(navigator: LinkNavigatorType) {
    self.navigator = navigator
  }
}

// MARK: Page1SideEffect

extension Page1SideEffectLive: Page1SideEffect {

  public var getPaths: () -> [String] {
    {
      navigator.currentPaths
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
