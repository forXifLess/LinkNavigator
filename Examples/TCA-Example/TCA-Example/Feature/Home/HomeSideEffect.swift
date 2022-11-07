import LinkNavigator

public protocol HomeSideEffect {

  var getPaths: () -> [String] { get }
  var routeToPage1: () -> Void { get }
  var routeToPage3: () -> Void { get }
  var showAlert: () -> Void { get }
  var routeToSheet: () -> Void { get }
  var routeToFullSheet: () -> Void { get }
}

public struct HomeSideEffectLive {
  let navigator: LinkNavigatorType

  public init(navigator: LinkNavigatorType) {
    self.navigator = navigator
  }
}

extension HomeSideEffectLive: HomeSideEffect {

  public var getPaths: () -> [String] {
    {
      navigator.currentPaths
    }
  }

  public var routeToPage1: () -> Void {
    {
      navigator.next(paths: ["page1"], items: [:], isAnimated: true)
    }
  }

  public var routeToPage3: () -> Void {
    {
      navigator.next(paths: ["page1", "page2", "page3"], items: [:], isAnimated: true)
    }
  }

  public var showAlert: () -> Void {
    {
      let alertModel = Alert(
        title: "Title",
        message: "message",
        buttons: [.init(title: "OK", style: .default, action: { print("OK tapped") })],
        flagType: .default)
      navigator.alert(target: .default, model: alertModel)
    }
  }

  public var routeToSheet: () -> Void {
    {
      navigator.sheet(paths: ["page1", "page2"], items: [:], isAnimated: true)
    }
  }

  public var routeToFullSheet: () -> Void {
    {
      navigator.fullSheet(paths: ["page1", "page2"], items: [:], isAnimated: true)
    }
  }
}
