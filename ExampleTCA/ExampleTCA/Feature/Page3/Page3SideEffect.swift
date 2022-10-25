import LinkNavigator

public protocol Page3SideEffect {

  var getPaths: () -> [String] { get }
  var routeToHome: () -> Void { get }
  var removePage1And2: () -> Void { get }
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

  public var getPaths: () -> [String] {
    {
      navigator.currentPaths
    }
  }

  public var routeToHome: () -> Void {
    {
      navigator.backOrNext(path: "home", items: [:], isAnimated: true)
    }
  }

  public var removePage1And2: () -> Void {
    {
      navigator.remove(paths: ["page1", "page2"])
    }
  }

  public var routeToBack: () -> Void {
    {
      navigator.back(isAnimated: true)
    }
  }

  public var routeToClose: () -> Void {
    {
      navigator.close(isAnimated: true) {
        print("modal dismissed!")
        navigator.rootReloadLast(isAnimated: false, items: [:])
      }
    }
  }

  public var routeToReset: () -> Void {
    {
      navigator.replace(paths: ["home"], items: [:], isAnimated: true)
    }
  }

}
