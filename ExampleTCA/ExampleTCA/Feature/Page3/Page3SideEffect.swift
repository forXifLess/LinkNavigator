import LinkNavigator

public protocol Page3SideEffect {

  var getRootPath: () -> [String] { get }
  var getSubPath: () -> [String] { get }
  var routeToHome: () -> Void { get }
  var deleteToPage1And2: () -> Void { get }
  var routeToBack: () -> Void { get }
  var routeToClose: () -> Void { get }
  var routeToReset: () -> Void { get }
}

public struct Page3SideEffectLive {
  let navigator: LinkNavigatorType

  public init(navigator: LinkNavigatorType) {
    self.navigator = navigator
  }
}

extension Page3SideEffectLive: Page3SideEffect {

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

  public var routeToHome: () -> Void {
    {
      navigator.backOrNext(path: "home", items: [:], isAnimated: true)
    }
  }

  public var deleteToPage1And2: () -> Void {
    {
      navigator.remove(paths: ["page1", "page2"])
    }
  }

  public var routeToClose: () -> Void {
    {
      navigator.close(isAnimated: true) { print("modal dismissed!") }
    }
  }

  public var routeToReset: () -> Void {
    {
      navigator.replace(paths: ["home"], items: [:], isAnimated: true)
    }
  }

  public var routeToBack: () -> Void {
    {
      navigator.back(isAnimated: true)
    }
  }
}
