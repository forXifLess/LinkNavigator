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
  private(set) var rootHistoryStack = HistoryStack()
  private(set) var subHistoryStack = HistoryStack()

  let enviroment: EnviromentType
  let routerGroup: RouterBuildGroupType

  public init(enviroment: EnviromentType, routerGroup: RouterBuildGroupType) {
    self.enviroment = enviroment
    self.routerGroup = routerGroup
  }
}

extension LinkNavigator: LinkNavigatorType {

  public var isOpenedModal: Bool {
    rootNavigationController.presentedViewController != .none
  }

  public func back(animated: Bool) {
    guard rootNavigationController.presentedViewController != .none else {
      rootNavigationController.popViewController(animated: animated)
      return
    }

    guard subNavigationController.viewControllers.count > 1 else {
      rootNavigationController.dismiss(animated: animated, completion: .none)
      return
    }

    subNavigationController.popViewController(animated: animated)
  }

  public func dismiss(animated: Bool) {
    rootNavigationController.dismiss(animated: animated, completion: .none)
  }

  public func href(url: String, animated: Bool, didOccuredError: ((LinkNavigatorType, LinkNavigatorError) -> Void)?) {
    href(url: url, target: .default, animated: animated, didOccuredError: didOccuredError)
  }

  public func href(url: String, target: LinkTarget, animated: Bool, didOccuredError: ((LinkNavigatorType, LinkNavigatorError) -> Void)?) {
    switch target {
    case .default:
      href(url: url, target: isOpenedModal ? .sheet : .root, animated: animated, didOccuredError: didOccuredError)

    case .root:
      href(
        historyStack: rootHistoryStack,
        navigatorController: rootNavigationController,
        url: url,
        animated: animated,
        didCompleted: {[weak self] newStack in
          guard let self = self else { return }
          self.rootHistoryStack = self.rootHistoryStack.mutate(stack: newStack)
        },
        didOccuredError: didOccuredError)
      
    case .sheet:
      href(
        historyStack: subHistoryStack,
        navigatorController: subNavigationController,
        url: url,
        animated: animated,
        didCompleted: {[weak self] newStack in
          guard let self = self else { return }
          self.subHistoryStack = self.subHistoryStack.mutate(stack: newStack)
        },
        didOccuredError: didOccuredError)

    }

  }

  public func alert(model: Alert) {
    rootNavigationController.present(model.build(), animated: true, completion: .none)
  }

  @discardableResult
  public func replace(url: String, animated: Bool, didOccuredError: (
    (LinkNavigatorType, LinkNavigatorError) -> Void)?) -> RootNavigator {
      replace(url: url, target: .default, animated: animated, didOccuredError: didOccuredError)
  }

  @discardableResult
  public func replace(url: String, target: LinkTarget, animated: Bool, didOccuredError: ((LinkNavigatorType, LinkNavigatorError) -> Void)?) -> RootNavigator {

    switch target {
    case .root, .default:
      return replace(
        historyStack: rootHistoryStack,
        navigationController: rootNavigationController,
        navigator: rootNavigator,
        url: url,
        didCompleted: { [weak self] stack in
          guard let self = self else { return }
          self.rootHistoryStack = self.rootHistoryStack.mutate(stack: stack)
          self.rootNavigationController.setViewControllers(self.rootHistoryStack.stack.map(\.viewController), animated: animated)
        },
        didOccuredError: didOccuredError)

    case .sheet:
      return replace(
        historyStack: subHistoryStack,
        navigationController: subNavigationController,
        navigator: subNavigator,
        url: url, didCompleted: { [weak self] newStack in
          guard let self = self else { return }
          self.subHistoryStack = self.subHistoryStack.mutate(stack: newStack)
          self.subNavigationController.setViewControllers(self.subHistoryStack.stack.map(\.viewController), animated: animated)

          if self.rootNavigationController.presentedViewController == .none {
            self.rootNavigationController.present(self.subNavigationController, animated: animated, completion: .none)
          }
        },
        didOccuredError: didOccuredError)
    }
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

  fileprivate func href(
    historyStack: HistoryStack,
    navigatorController: RootNavigationController,
    url: String,
    animated: Bool,
    didCompleted: @escaping ([ViewableRouter]) -> Void,
    didOccuredError: ((LinkNavigatorType, LinkNavigatorError) -> Void)?) {
    let currentViewControllers = navigatorController.viewControllers.compactMap {
      $0 as? WrapperController
    }
    let newHistory = historyStack.reorderStack(viewControllers: currentViewControllers)
    guard let absURL = convertAbsolute(url: url, matches: newHistory.stack.map(\.matchURL)) else { return }
    guard let matchURL = MatchURL.serialzied(url: absURL) else { return }

    do {
      let newStack = try routerGroup.build(
        history: newHistory,
        match: matchURL,
        enviroment: enviroment,
        navigator: self)

      didCompleted(newStack)
      navigatorController
        .setViewControllers(newStack.map(\.viewController), animated: animated)
    } catch {
      didOccuredError?(self, .notFound)
    }
  }

  fileprivate func replace(historyStack: HistoryStack, navigationController: RootNavigationController, navigator: RootNavigator, url: String, didCompleted: @escaping ([ViewableRouter]) -> Void, didOccuredError: ((LinkNavigatorType, LinkNavigatorError) -> Void)?) -> RootNavigator {
    guard let matchURL = MatchURL.serialzied(url: url) else {
      didOccuredError?(self, .notAllowedURL)
      return navigator
    }

    do {
      let newStack = try routerGroup.build(
        history: .init(),
        match: matchURL,
        enviroment: enviroment,
        navigator: self)

      navigationController.dismiss(animated: false) {
        didCompleted(newStack)
      }
    } catch {
      didOccuredError?(self, .notFound)
    }

    return navigator
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
