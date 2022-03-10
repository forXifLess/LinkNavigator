import UIKit
import SwiftUI

public final class LinkNavigator {
  let rootNavigationController = RootNavigationController()
  let subNavigationController = RootNavigationController()

  lazy var rootNavigator: RootNavigator = {
    RootNavigator(navigationController: rootNavigationController)
  }()
  lazy var subNavigator: RootNavigator = {
    RootNavigator(navigationController: subNavigationController)
  }()
  private(set) var currentHistoryStack = HistoryStack()
  let enviroment: EnviromentType
  let routerGroup: RouterBuildGroupType

  public init(enviroment: EnviromentType, routerGroup: RouterBuildGroupType) {
    self.enviroment = enviroment
    self.routerGroup = routerGroup
  }
}

extension LinkNavigator: LinkNavigatorType {

  public func back(animated: Bool) {
    if rootNavigationController.presentedViewController == .none {
      rootNavigationController.popViewController(animated: animated)
    } else {
      rootNavigationController.dismiss(animated: animated, completion: .none)
    }
  }

  public func href(url: String, animated: Bool, didOccuredError: ((LinkNavigatorType, LinkNavigatorError) -> Void)?) {
    let currentViewControllers = rootNavigationController.viewControllers.compactMap {
      $0 as? WrapperController
    }
    let newHistory = currentHistoryStack.reorderStack(viewControllers: currentViewControllers)
    guard let absURL = convertAbsolute(url: url, matches: newHistory.stack.map(\.matchURL)) else { return }
    guard let matchURL = MatchURL.serialzied(url: absURL) else { return }

    do {
      let newStack = try routerGroup.build(
        history: newHistory,
        match: matchURL,
        enviroment: enviroment,
        navigator: self)

      currentHistoryStack = currentHistoryStack.mutate(stack: newStack)

      rootNavigationController
        .setViewControllers(currentHistoryStack.stack.map(\.viewController), animated: animated)
    } catch {
      didOccuredError?(self, .notFound)
      return
    }
  }

  public func alert(model: Alert) {
    rootNavigationController.present(model.build(), animated: true, completion: .none)
  }

  public func sheet(url: String, animated: Bool, didOccuredError: ((LinkNavigatorType, LinkNavigatorError) -> Void)?) {
    guard let matchURL = MatchURL.serialzied(url: url) else {
      didOccuredError?(self, .notAllowedURL)
      return
    }

    do {
      let openStack = try routerGroup.build(
        history: .init(),
        match: matchURL,
        enviroment: enviroment,
        navigator: self)

      rootNavigationController.dismiss(animated: animated) { [weak self] in
        guard let self = self else { return }
        let subHistory = HistoryStack(stack: openStack)
        self.subNavigationController.setViewControllers(subHistory.stack.map(\.viewController), animated: false)
        self.rootNavigationController.present(self.subNavigationController, animated: animated, completion: .none)
      }
    } catch {
      rootNavigationController.dismiss(animated: false, completion: .none)
      didOccuredError?(self, .notFound)
    }
  }

  @discardableResult
  public func replace(url: String, animated: Bool, didOccuredError: ((LinkNavigatorType, LinkNavigatorError) -> Void)?) -> RootNavigator {
    guard let matchURL = MatchURL.serialzied(url: url) else {
      didOccuredError?(self, .notAllowedURL)
      return rootNavigator
    }

    do {
      let newStack = try routerGroup.build(
        history: .init(),
        match: matchURL,
        enviroment: enviroment,
        navigator: self)

      currentHistoryStack = currentHistoryStack.mutate(stack: newStack)
      rootNavigationController.dismiss(animated: false) { [weak self] in
        guard let self = self else { return }
        self.rootNavigationController
          .setViewControllers(self.currentHistoryStack.stack.map(\.viewController), animated: animated)
      }
    } catch {
      didOccuredError?(self, .notFound)
    }

    return rootNavigator
  }
}

extension LinkNavigator {
  fileprivate func convertAbsolute(url: String, matches: [MatchURL]) -> String? {
    guard let compoent = URLComponents(string: url) else { return .none }
    guard compoent.host == .none else { return url }
    guard let lastMatch = matches.last else { return .none }
    guard let convertedURL = compoent.url?.absoluteString else { return .none }

    return lastMatch.pathes.joined(separator: "/") + convertedURL
  }
}

public struct RootNavigator: UIViewControllerRepresentable {

  let navigationController: UINavigationController

  public func makeUIViewController(context: Context) -> some UIViewController {
    navigationController
  }

  public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
  }
}
