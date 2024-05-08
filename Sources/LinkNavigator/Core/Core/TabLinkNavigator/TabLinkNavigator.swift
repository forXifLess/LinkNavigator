import UIKit

// MARK: - TabLinkNavigator

public final class TabLinkNavigator {

  // MARK: Lifecycle

  public init(
    routeBuilderItemList: [RouteBuilderOf<TabPartialNavigator>],
    dependency: DependencyType)
  {
    self.routeBuilderItemList = routeBuilderItemList
    self.dependency = dependency
    coordinate = .init(sheetDidDismiss: { [weak self] presentVC in
      if presentVC.presentedViewController == self?.fullSheetController {
        self?.fullSheetController = .none
      } else {
        self?.modalController = .none
      }
      presentVC.delegate = .none
    })
  }

  // MARK: Public

  public let routeBuilderItemList: [RouteBuilderOf<TabPartialNavigator>]
  public let dependency: DependencyType

  public var tabRootPartialNavigators: [TabPartialNavigator] = []

  public var owner: LinkNavigatorItemSubscriberProtocol? = .none

  public weak var mainController: UITabBarController?

  public var currentTabRootPath: String? {
    ((mainController?.selectedViewController as? UINavigationController)?.viewControllers.first as? MatchPathUsable)?.matchPath
  }

  public var currentPath: String? {
    ((mainController?.selectedViewController as? UINavigationController)?.topViewController as? MatchPathUsable)?.matchPath
  }

  // MARK: Internal

  var modalController: UINavigationController? = .none
  var fullSheetController: UINavigationController? = .none

  // MARK: Private

  // MARK: - Private Properties

  private var coordinate: SheetCoordinate = .init(sheetDidDismiss: { _ in })

}

extension TabLinkNavigator {
  public func targetController(targetTabPath: String) -> UINavigationController? {
    tabRootPartialNavigators.first(where: { $0.getCurrentRootPaths().first == targetTabPath })?.currentTabNavigationController
  }

  public func targetPartialNavigator(tabPath: String) -> TabPartialNavigator? {
    tabRootPartialNavigators.first(where: { $0.getCurrentRootPaths().first == tabPath })
  }
}

extension TabLinkNavigator {
  public func launch(tagItemList: [TabItem]) -> [UINavigationController] {
    let partialNavigators = tagItemList
      .reduce([(Bool, TabPartialNavigator)]()) { curr, next in
        let newNavigatorList = TabPartialNavigator(
          rootNavigator: self,
          tabItem: next,
          routeBuilderItemList: routeBuilderItemList,
          dependency: dependency)
        return curr + [(next.prefersLargeTitles, newNavigatorList)]
      }

    self.tabRootPartialNavigators = partialNavigators.map(\.1)

    return partialNavigators
      .map { (prefersLargeTitles, navigator) in
        let partialNavigationVC = navigator.launch(rootPath: navigator.tabItem.linkItem.pathList.first ?? "")
        let item = tagItemList.first(where: { $0.linkItem == navigator.tabItem.linkItem })
        partialNavigationVC.navigationController.tabBarItem = item?.tabItem
        partialNavigationVC.navigationController.navigationBar.prefersLargeTitles = prefersLargeTitles
        return partialNavigationVC.navigationController
      }
  }
}

extension TabLinkNavigator {
  public func sheetOpen(
    subViewController: UINavigationController,
    isAnimated: Bool,
    type: UIModalPresentationStyle,
    presentWillAction: @escaping (UINavigationController) -> Void = { _ in },
    presentDidAction: @escaping (UINavigationController) -> Void = { _ in })
  {
    if modalController != .none {
      modalController?.dismiss(animated: true)
      modalController = .none
    }

    presentWillAction(subViewController)

    switch type {
    case .fullScreen, .overFullScreen:
      if let fullSheetController {
        subViewController.modalPresentationStyle = .formSheet
        fullSheetController.present(subViewController, animated: isAnimated)
        modalController = subViewController
      } else {
        mainController?.present(subViewController, animated: isAnimated)
        fullSheetController = subViewController
      }

    default:
      if let fullSheetController {
        fullSheetController.present(subViewController, animated: isAnimated)
      } else {
        mainController?.present(subViewController, animated: isAnimated)
      }
      modalController = subViewController
    }

    subViewController.presentationController?.delegate = coordinate
    presentDidAction(subViewController)
  }

  public func close(isAnimated: Bool, completion: () -> Void) {
    if let modalController {
      modalController.dismiss(animated: isAnimated)
      self.modalController = .none
    } else if let fullSheetController {
      fullSheetController.dismiss(animated: isAnimated)
      self.fullSheetController = .none
    }

    completion()
  }

  public func closeAll(isAnimated: Bool, completion: () -> Void) {
    mainController?.dismiss(animated: isAnimated)
    modalController = .none
    fullSheetController = .none
    completion()
  }

  public func moveTab(targetPath: String) {
    guard let targetController = tabRootPartialNavigators.first(where: { $0.getCurrentRootPaths().first == targetPath })?.currentTabNavigationController else { return }

    if mainController?.selectedViewController == targetController {
      targetController.popToRootViewController(animated: true)
    } else {
      mainController?.selectedViewController = targetController
    }

    NotificationCenter.default
      .post(name: TabbarEventNotification.onSelectedTab, object: targetPath)
  }

  public func alert(model: Alert) {
    let currentController = modalController ?? fullSheetController ?? mainController?.selectedViewController
    currentController?.present(model.build(), animated: true)
  }

  /// Sends event to navigators that match path of link item
  public func send(linkItem: LinkItem) {
    var matchPathUsables: [MatchPathUsable] = []

    matchPathUsables = tabRootPartialNavigators
      .flatMap(\.currentTabNavigationController.viewControllers)
      .compactMap { $0 as? MatchPathUsable }

    matchPathUsables
      .filter { linkItem.pathList.contains($0.matchPath) }
      .forEach {
        $0.eventSubscriber?.receive(encodedItemString: linkItem.encodedItemString)
      }
  }
}
