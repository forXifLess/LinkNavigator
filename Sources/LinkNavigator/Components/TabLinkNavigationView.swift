import Foundation
import SwiftUI

// MARK: - TabLinkNavigationView

public struct TabLinkNavigationView {
  let linkNavigator: TabLinkNavigator
  let isHiddenDefaultTabbar: Bool
  let tabItemList: [TabItem]
  let isAnimatedForUpdateTabbar: Bool

  public init(
    linkNavigator: TabLinkNavigator,
    isHiddenDefaultTabbar: Bool,
    tabItemList: [TabItem],
    isAnimatedForUpdateTabbar: Bool = false)
  {
    self.linkNavigator = linkNavigator
    self.isHiddenDefaultTabbar = isHiddenDefaultTabbar
    self.tabItemList = tabItemList
    self.isAnimatedForUpdateTabbar = isAnimatedForUpdateTabbar
  }
}

// MARK: UIViewControllerRepresentable

extension TabLinkNavigationView: UIViewControllerRepresentable {
  public func makeCoordinator() -> Coordinator {
    Coordinator()
  }

  public func makeUIViewController(context _: Context) -> UITabBarController {
    UITabBarController()
  }

  /// `launch(tagItemList:)` 는 탭별 네비게이터와 루트 페이지를 전부 새로 만들기 때문에,
  /// SwiftUI 가 부모 body 를 재평가할 때마다 호출하면 `replace` 등으로 옮겨둔 화면이
  /// `tabItemList` 기준으로 롤백된다. 라우팅에 영향을 주는 값이 실제로 바뀐 경우에만 재구성한다.
  public func updateUIViewController(_ uiViewController: UITabBarController, context: Context) {
    let routeSignature = tabItemList.map(RouteSignature.init)
    let isChangedRoute = context.coordinator.appliedRouteSignature != routeSignature

    if isChangedRoute {
      context.coordinator.appliedRouteSignature = routeSignature
      uiViewController.setViewControllers(
        linkNavigator.launch(tagItemList: tabItemList),
        animated: isAnimatedForUpdateTabbar)
    } else {
      // 스택 재구성 없이 탭바 아이템만 반영한다(랭셋 변경 등으로 UITabBarItem 만 새로 만들어진 경우).
      zip(uiViewController.viewControllers ?? [], tabItemList).forEach { controller, item in
        controller.tabBarItem = item.tabItem
      }
    }

    if uiViewController.tabBar.isHidden != isHiddenDefaultTabbar {
      uiViewController.tabBar.isHidden = isHiddenDefaultTabbar
    }

    linkNavigator.mainController = uiViewController
  }
}

// MARK: TabLinkNavigationView.Coordinator

extension TabLinkNavigationView {
  public final class Coordinator {
    var appliedRouteSignature: [RouteSignature] = []
  }

  /// 네비게이션 스택 재구성 여부를 판단하는 값.
  /// `TabItem.tabItem`(`UITabBarItem`)은 갱신 때마다 새 인스턴스로 만들어져 비교에 쓸 수 없으므로 제외한다.
  struct RouteSignature: Equatable {

    // MARK: Lifecycle

    init(_ tabItem: TabItem) {
      tag = tabItem.tag
      linkItem = tabItem.linkItem
      prefersLargeTitles = tabItem.prefersLargeTitles
    }

    // MARK: Internal

    let tag: Int
    let linkItem: LinkItem
    let prefersLargeTitles: Bool
  }
}
