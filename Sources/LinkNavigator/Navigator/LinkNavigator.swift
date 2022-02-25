import UIKit
import SwiftUI

public final class LinkNavigator {
  var rootNavigationController = RootNavigationController()
  lazy var rootNavigator: RootNavigator = {
    RootNavigator(navigationController: rootNavigationController)
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
  public func back() {
    rootNavigationController.popViewController(animated: true)
  }

  public func href(url: String, didOccuredError: ((LinkNavigatorType, LinkNavigatorError) -> Void)?) {
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
        .setViewControllers(currentHistoryStack.stack.map(\.viewController), animated: true)
    } catch {
      didOccuredError?(self, .notFound)
      return
    }
  }

  func convertAbsolute(url: String, matches: [MatchURL]) -> String? {
    guard let compoent = URLComponents(string: url) else { return .none }
    guard compoent.host == .none else { return url }
    guard let lastMatch = matches.last else { return .none }
    guard let convertedURL = compoent.url?.absoluteString else { return .none }

    return lastMatch.pathes.joined(separator: "/") + convertedURL
  }

  @discardableResult
  public func replace(url: String, didOccuredError: ((LinkNavigatorType, LinkNavigatorError) -> Void)?) -> RootNavigator {
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

      rootNavigationController
        .setViewControllers(currentHistoryStack.stack.map(\.viewController), animated: true)
    } catch {
      didOccuredError?(self, .notFound)
    }

    return rootNavigator
  }

  public func alert(model: Alert) {
    rootNavigationController.present(model.build(), animated: true, completion: .none)
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
