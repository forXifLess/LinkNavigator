//
//  File.swift
//
//
//  Created by 조상호 on 2023/09/06.
//

import Foundation
import UIKit

public struct NavigatorBuilder {

  // MARK: Lifecycle

  private init() { }

  // MARK: Public

  public typealias MatchedViewController = MatchPathUsable & UIViewController

  public static func build<Root, ItemValue>(
    rootNavigator: Root,
    item: LinkItem<ItemValue>,
    routeBuilderList: [RouteBuilderOf<Root, ItemValue>],
    dependency: DependencyType) -> [RouteViewController]
  {
    item.pathList.compactMap { path in
      routeBuilderList.first(where: { $0.matchPath == path })?.routeBuild(rootNavigator, item.items, dependency)
    }
  }

  public static func pickBuild<Root, ItemValue>(
    rootNavigator: Root,
    item: LinkItem<ItemValue>,
    routeBuilderList: [RouteBuilderOf<Root, ItemValue>],
    dependency: DependencyType)
    -> RouteViewController?
  {
    routeBuilderList
      .first(where: { $0.matchPath == (item.pathList.first ?? "") })?
      .routeBuild(rootNavigator, item.items, dependency)
  }

  public static func firstPick<ItemValue>(
    controller: UINavigationController?,
    item: LinkItem<ItemValue>)
    -> RouteViewController?
  {
    guard let controller, let first = item.pathList.first else { return .none }
    return controller.viewControllers
      .compactMap { $0 as? RouteViewController }
      .first(where: { $0.matchPath == first })
  }

  public static func lastPick<ItemValue>(controller: UINavigationController?, item: LinkItem<ItemValue>) -> RouteViewController? {
    guard let controller, let first = item.pathList.first else { return .none }
    return controller.viewControllers
      .compactMap { $0 as? RouteViewController }
      .last(where: { $0.matchPath == first })
  }

  public static func exceptFilter<ItemValue>(
    controller: UINavigationController?,
    item: LinkItem<ItemValue>) -> [RouteViewController]
  {
    (controller?.viewControllers ?? [])
      .compactMap { $0 as? MatchedViewController }
      .filter { !item.pathList.contains($0.matchPath) }
  }

}
