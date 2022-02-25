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

  public func href(url: String) {
    let currentViewControllers = rootNavigationController.viewControllers.compactMap {
      $0 as? WrapperController
    }
    let newHistory = currentHistoryStack.reorderStack(viewControllers: currentViewControllers)
    guard let absURL = convertAbsolute(url: url, matches: newHistory.stack.map(\.matchURL)) else { return }
    guard let matchURL = MatchURL.serialzied(url: absURL) else { return }

    let newStack = routerGroup.build(
      history: newHistory,
      match: matchURL,
      enviroment: enviroment,
      navigator: self)

    currentHistoryStack = currentHistoryStack.mutate(stack: newStack)

    rootNavigationController
      .setViewControllers(currentHistoryStack.stack.map(\.viewController), animated: true)
  }

  func convertAbsolute(url: String, matches: [MatchURL]) -> String? {
    guard let compoent = URLComponents(string: url) else { return .none }
    guard compoent.host == .none else { return url }
    guard let lastMatch = matches.last else { return .none }
    guard let convertedURL = compoent.url?.absoluteString else { return .none }

    return lastMatch.pathes.joined(separator: "/") + convertedURL
  }

  public func replace(url: String) {
    guard let matchURL = MatchURL.serialzied(url: url) else { return }

    let newStack = routerGroup.build(
      history: .init(),
      match: matchURL,
      enviroment: enviroment,
      navigator: self)

    currentHistoryStack = currentHistoryStack.mutate(stack: newStack)

    rootNavigationController.dismiss(animated: false)
    rootNavigationController
      .setViewControllers(currentHistoryStack.stack.map(\.viewController), animated: false)
  }
}

struct RootNavigator: UIViewControllerRepresentable {

  let navigationController: UINavigationController

  func makeUIViewController(context: Context) -> some UIViewController {
    navigationController
  }

  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
  }
}
