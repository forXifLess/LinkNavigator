import LinkNavigator

public protocol Page3SideEffect {

  var getPaths: () -> [String] { get }
  var routeToPage4: (String) -> Void { get }
  var removePage1And2: () -> Void { get }
  var routeToBack: () -> Void { get }
  var routeToClose: () -> Void { get }
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

  public var routeToPage4: (String) -> Void {
    { messageYouTyped in
      navigator.next(paths: ["page4"], items: ["page4-message": messageYouTyped], isAnimated: true)
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

}
