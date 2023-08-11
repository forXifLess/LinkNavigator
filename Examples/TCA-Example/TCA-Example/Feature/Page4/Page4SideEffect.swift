import LinkNavigator
import UIKit

// MARK: - Page4SideEffect

public protocol Page4SideEffect {

  var getPaths: () -> [String] { get }
  var routeToHome: () -> Void { get }
  var routeToBack: () -> Void { get }
  var routeToReset: () -> Void { get }
  var openSafari: (String) -> Void { get }
}

// MARK: - Page4SideEffectLive

public struct Page4SideEffectLive {
  let navigator: LinkNavigatorType

  public init(navigator: LinkNavigatorType) {
    self.navigator = navigator
  }
}

// MARK: Page4SideEffect

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

  public var openSafari: (String) -> Void {
    {
      guard let url = URL(string: $0), UIApplication.shared.canOpenURL(url) else { return }
      UIApplication.shared.open(url, options: [:], completionHandler: .none)
    }
  }

}
