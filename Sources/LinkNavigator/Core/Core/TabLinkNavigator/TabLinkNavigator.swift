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

  public var tabRootNavigators: [TabRootNavigationController] = []

  public var owner: LinkNavigatorItemSubscriberProtocol? = .none

  public weak var mainController: UITabBarController?

  public var currentTabRootPath: String? {
    guard let currentController = mainController?.selectedViewController else { return .none }
    let currentTabRootController = tabRootNavigators.first(where: { $0.navigationController == currentController })

    return currentTabRootController?.matchPath
  }

  public var currentPath: String? {
    (tabRootNavigators.first(where: {
      $0.navigationController == mainController?.selectedViewController
    })?.navigationController.topViewController as? MatchPathUsable)?.matchPath
  }

  // MARK: Internal

  var modalController: UINavigationController? = .none
  var fullSheetController: UINavigationController? = .none

  // MARK: Private

  // MARK: - Private Properties

  private var coordinate: SheetCoordinate = .init(sheetDidDismiss: { _ in })

}

extension TabLinkNavigator {
  func targetController(targetTabPath: String) -> UINavigationController? {
    tabRootNavigators.first(where: { $0.matchPath == targetTabPath })?.navigationController
  }
}

extension TabLinkNavigator {
  public func launch(tagItemList: [TabItem]) -> [UINavigationController] {
    let tabPartialNavigators = tagItemList
      .reduce([(Bool, TabPartialNavigator)]()) { curr, next in
        let newNavigatorList = TabPartialNavigator(
          rootNavigator: self,
          tabItem: next,
          routeBuilderItemList: routeBuilderItemList,
          dependency: dependency)
        return curr + [(next.prefersLargeTitles, newNavigatorList)]
      }

    tabRootNavigators = tabPartialNavigators
      .map { (prefersLargeTitles, navigator) in
        let partialNavigationVC = navigator.launch(rootPath: navigator.tabItem.linkItem.pathList.first ?? "")
        let item = tagItemList.first(where: { $0.linkItem == navigator.tabItem.linkItem })
        partialNavigationVC.navigationController.tabBarItem = item?.tabItem
        partialNavigationVC.navigationController.navigationBar.prefersLargeTitles = prefersLargeTitles
        return partialNavigationVC
      }

    return tabRootNavigators.map(\.navigationController)
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
    guard let targetController = tabRootNavigators.first(where: { $0.matchPath == targetPath })?.navigationController
    else { return }

    if mainController?.selectedViewController == targetController {
      targetController.popToRootViewController(animated: true)
    } else {
      mainController?.selectedViewController = targetController
    }

    NotificationCenter.default
      .post(name: TabbarEventNotification.onSelectedTab, object: targetPath)
  }
}

extension UINavigationController {
  private func currentItemList() -> [String] {
    viewControllers.compactMap { $0 as? MatchPathUsable }.map(\.matchPath)
  }

  private func merge(new: [UIViewController], isAnimated: Bool) {
    setViewControllers(viewControllers + new, animated: isAnimated)
  }

  private func back(isAnimated: Bool) {
    popViewController(animated: isAnimated)
  }

  private func clear(isAnimated: Bool) {
    setViewControllers([], animated: isAnimated)
  }

  private func push(viewController: UIViewController?, isAnimated: Bool) {
    guard let viewController else { return }
    pushViewController(viewController, animated: isAnimated)
  }

  private func replace(viewController: [UIViewController], isAnimated: Bool) {
    setViewControllers(viewController, animated: isAnimated)
  }

  private func popTo(viewController: UIViewController?, isAnimated: Bool) {
    guard let viewController else { return }
    popToViewController(viewController, animated: isAnimated)
  }

  private func dropLast() -> [UIViewController] {
    Array(viewControllers.dropLast())
  }
}
