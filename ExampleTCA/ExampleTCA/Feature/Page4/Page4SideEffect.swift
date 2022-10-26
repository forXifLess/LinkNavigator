import LinkNavigator

public protocol Page4SideEffect {

  var getPaths: () -> [String] { get }
  var routeToHome: () -> Void { get }
  var routeToBack: () -> Void { get }
  var routeToReset: () -> Void { get }
}

public struct Page4SideEffectLive {
  let navigator: LinkNavigatorType

  public init(navigator: LinkNavigatorType) {
    self.navigator = navigator
  }
}

extension Page4SideEffectLive: Page4SideEffect {

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

  public var routeToBack: () -> Void {
    {
      navigator.back(isAnimated: true)
    }
  }

  public var routeToReset: () -> Void {
    {
      navigator.replace(paths: ["home"], items: [:], isAnimated: true)
    }
  }

}
