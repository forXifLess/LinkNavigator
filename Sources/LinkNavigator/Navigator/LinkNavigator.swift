#if canImport(UIKit)

import UIKit
import SwiftUI

public final class LinkNavigator {
  let rootNavigationController: RootNavigationController
  let subNavigationController: RootNavigationController
  let defaultScheme: String

  lazy var rootNavigator: RootNavigator = {
    RootNavigator(navigationController: rootNavigationController)
  }()
  lazy var subNavigator: RootNavigator = {
    RootNavigator(navigationController: subNavigationController)
  }()
  private(set) var rootHistoryStack = HistoryStack()
  private(set) var subHistoryStack = HistoryStack()

  let environment: EnvironmentType
  let routerGroup: RouterBuildGroupType

  public init(
    rootNavigationBarHidden: Bool = false,
    subNavigationBarHidden: Bool = false,
    defaultScheme: String,
    environment: EnvironmentType,
    routerGroup: RouterBuildGroupType)
  {
    self.defaultScheme = defaultScheme
    self.environment = environment
    self.routerGroup = routerGroup

    rootNavigationController = .init()
    rootNavigationController.isNavigationBarHidden = rootNavigationBarHidden

    subNavigationController = .init()
    subNavigationController.isNavigationBarHidden = rootNavigationBarHidden
  }
}

extension LinkNavigator: LinkNavigatorType {

  public var isOpenedModal: Bool {
    rootNavigationController.presentedViewController != .none
  }

  public var currentPath: [String] {
    rootHistoryStack.stack.map(\.key)
  }

  public func isCurrentContain(path: String) -> Bool {
    isOpenedModal
      ? isContain(navigationController: subNavigationController, path: path)
      : isContain(navigationController: rootNavigationController, path: path)
  }

  public func getPath(locationPath: String) -> [String] {
    let endIndex = currentPath.enumerated().first(where: {$0.element == locationPath})?.offset ?? currentPath.endIndex - 1
    return Array(currentPath[currentPath.startIndex...endIndex])
  }

  public func back(animated: Bool) {
    guard rootNavigationController.presentedViewController != .none else {
      rootNavigationController.popViewController(animated: true)
      rootHistoryStack = rootHistoryStack.mutate(stack: rootHistoryStack.stack.dropLast())
      return
    }

    guard subNavigationController.viewControllers.count > 1 else {
      rootNavigationController.dismiss(animated: animated, completion: .none)
      return
    }
    subNavigationController.popViewController(animated: animated)
    subHistoryStack = subHistoryStack.mutate(stack: subHistoryStack.stack.dropLast())
  }

  public func back(path: String, animated: Bool) {
    back(path: path, animated: animated, isReload: false)
  }

  public func back(path: String, animated: Bool, isReload: Bool) {
    back(path: path, target: .default, animated: animated, isReload: isReload)
  }

  public func back(path: String, target: LinkTarget, animated: Bool) {
    back(path: path, target: target, animated: animated, isReload: false)
  }

  public func back(path: String, target: LinkTarget, animated: Bool, isReload: Bool) {
    switch target {
    case .default:
      back(path: path, target: isOpenedModal ? .sheet : .root, animated: animated, isReload: isReload)
    case .root:
      removeBackPath(target: target, path: path)
      back(historyStack: rootHistoryStack, isReload: isReload, navigationController: rootNavigationController, path: path, animated: animated)
      clearSubNavigatorAndHistory()
    case .sheet, .sheetFull:
      removeBackPath(target: target, path: path)
      back(historyStack: subHistoryStack, isReload: isReload, navigationController: subNavigationController, path: path, animated: animated)
    }
  }

  public func back(path: String, target: LinkTarget, animated: Bool, callBackItem: [String : QueryItem]?) {
    switch target {
    case .default:
      back(path: path, target: isOpenedModal ? .sheet : .root, animated: animated, callBackItem: callBackItem ?? [:])
    case .root:
      removeBackPath(target: target, path: path)
      back(historyStack: rootHistoryStack, callBackItem: callBackItem ?? [:], navigationController: rootNavigationController, path: path, animated: animated)
      clearSubNavigatorAndHistory()
    case .sheet, .sheetFull:
      removeBackPath(target: target, path: path)
      back(historyStack: subHistoryStack, callBackItem: callBackItem ?? [:], navigationController: subNavigationController, path: path, animated: animated)
    }
  }

  public func dismiss(animated: Bool, didCompletion: (() -> Void)?) {
    rootNavigationController.dismiss(animated: animated, completion: { [weak self] in
      self?.clearSubNavigatorAndHistory()
      didCompletion?()
    })
  }

  public func href(url: String, animated: Bool, errorAction: ((LinkNavigatorType, LinkNavigatorError) -> Void)?) {
    href(url: url, target: .default, animated: animated, errorAction: errorAction)
  }

  public func href(url: String, target: LinkTarget, animated: Bool, errorAction: ((LinkNavigatorType, LinkNavigatorError) -> Void)?) {
    switch target {
    case .default:
      href(url: url, target: isOpenedModal ? .sheet : .root, animated: animated, errorAction: errorAction)

    case .root:
      href(
        historyStack: rootHistoryStack,
        navigationController: rootNavigationController,
        url: url,
        animated: animated,
        didCompleted: {[weak self] newStack in
          guard let self = self else { return }
          self.rootHistoryStack = self.rootHistoryStack.mutate(stack: newStack)
          self.clearSubNavigatorAndHistory()
        },
        errorAction: errorAction)

    case .sheet, .sheetFull:
      if target == .sheetFull {
        subNavigationController.mutatedPresentationStyle(modalPresentationStyle: .fullScreen)
      } else {
        subNavigationController.mutatedPresentationStyle()
      }

      href(
        historyStack: subHistoryStack,
        navigationController: subNavigationController,
        url: url,
        animated: animated,
        didCompleted: {[weak self] newStack in
          guard let self = self else { return }
          self.subHistoryStack = self.subHistoryStack.mutate(stack: newStack)
        },
        errorAction: errorAction)

    }
  }

  public func href(paths: [String], queryItems: [String : QueryItemConvertable], target: LinkTarget, animated: Bool, errorAction: ((LinkNavigatorType, LinkNavigatorError) -> Void)?) {
    href(
      url: makeRelativeURL(paths: paths, queryItems: queryItems),
      target: target,
      animated: animated,
      errorAction: errorAction)
  }

  public func href(paths: [String], target: LinkTarget, animated: Bool, errorAction: ((LinkNavigatorType, LinkNavigatorError) -> Void)?) {
    href(
      url: makeRelativeURL(paths: paths, queryItems: [:]),
      target: target,
      animated: animated,
      errorAction: errorAction)
  }

  public func href(paths: [String], queryItems: [String : QueryItemConvertable], animated: Bool, errorAction: ((LinkNavigatorType, LinkNavigatorError) -> Void)?) {
    href(
      url: makeRelativeURL(paths: paths, queryItems: queryItems),
      animated: animated,
      errorAction: errorAction)
  }

  public func href(paths: [String], animated: Bool, errorAction: ((LinkNavigatorType, LinkNavigatorError) -> Void)?) {
    href(
      url: makeRelativeURL(paths: paths, queryItems: [:]),
      animated: animated,
      errorAction: errorAction)
  }

  public func remove(paths: [String], animated: Bool, target: LinkTarget) {
    switch target {
    case .default:
      return remove(paths: paths, animated: animated, target: isOpenedModal ? .sheet : .root)
    case .sheet, .sheetFull:
      return removePaths(historyStack: subHistoryStack, navigationController: subNavigationController, paths: paths, animated: animated)
    case .root:
      return removePaths(historyStack: rootHistoryStack, navigationController: rootNavigationController, paths: paths, animated: animated)
    }
  }

  public func alert(model: Alert) {
    alert(target: .default, model: model)
  }

  public func alert(target: LinkTarget, model: Alert) {
    switch target {
    case .default:
      return alert(target: isOpenedModal ? .sheet : .root, model: model)
    case .root:
      return rootNavigationController.present(model.build(), animated: true, completion: .none)
    case .sheet, .sheetFull:
      return subNavigationController.present(model.build(), animated: true, completion: .none)
    }
  }

  @discardableResult
  public func replace(url: String, animated: Bool, errorAction: (
    (LinkNavigatorType, LinkNavigatorError) -> Void)?) -> RootNavigator {
      replace(url: url, target: .default, animated: animated, errorAction: errorAction)
  }

  @discardableResult
  public func replace(url: String, target: LinkTarget, animated: Bool, errorAction: ((LinkNavigatorType, LinkNavigatorError) -> Void)?) -> RootNavigator {

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
          self.clearSubNavigatorAndHistory()
        },
        errorAction: errorAction)

    case .sheet, .sheetFull:
      if target == .sheetFull {
        subNavigationController.mutatedPresentationStyle(modalPresentationStyle: .fullScreen)
      } else {
        subNavigationController.mutatedPresentationStyle()
      }
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
        errorAction: errorAction)
    }
  }

  @discardableResult
  public func replace(paths: [String], queryItems: [String : QueryItemConvertable], animated: Bool, errorAction: ((LinkNavigatorType, LinkNavigatorError) -> Void)?) -> RootNavigator {
    replace(
      url: makeAbsoluteURL(paths: paths, queryItems: queryItems),
      animated: animated,
      errorAction: errorAction)
  }

  @discardableResult
  public func replace(paths: [String], animated: Bool, errorAction: ((LinkNavigatorType, LinkNavigatorError) -> Void)?) -> RootNavigator {
    replace(
      url: makeAbsoluteURL(paths: paths, queryItems: [:]),
      animated: animated,
      errorAction: errorAction)
  }

  @discardableResult
  public func replace(paths: [String], queryItems: [String : QueryItemConvertable], target: LinkTarget, animated: Bool, errorAction: ((LinkNavigatorType, LinkNavigatorError) -> Void)?) -> RootNavigator {
    replace(
      url: makeAbsoluteURL(paths: paths, queryItems: queryItems),
      target: target,
      animated: animated,
      errorAction: errorAction)
  }

  @discardableResult
  public func replace(paths: [String], target: LinkTarget, animated: Bool, errorAction: ((LinkNavigatorType, LinkNavigatorError) -> Void)?) -> RootNavigator {
    replace(
      url: makeAbsoluteURL(paths: paths, queryItems: [:]),
      target: target,
      animated: animated,
      errorAction: errorAction)
  }
}

extension LinkNavigator {
  fileprivate func convertAbsolute(url: String, matches: [MatchURL]) -> String? {
    guard let components = URLComponents(string: url) else { return .none }
    guard components.host == .none else { return url }
    guard let lastMatch = matches.last else { return .none }
    guard let convertedURL = components.url?.absoluteString else { return .none }

    return "\(defaultScheme)://" + lastMatch.paths.joined(separator: "/") + convertedURL
  }

  fileprivate func back(historyStack: HistoryStack, isReload: Bool, navigationController: RootNavigationController, path: String, animated: Bool) {
    let currentViewControllers = navigationController.viewControllers.compactMap {
      $0 as? WrapperController
    }

    guard let pickViewController = currentViewControllers.first(where: { $0.key == path }) else { return }
    if isReload { pickViewController.reloadCompletion?() }
    navigationController.popToViewController(pickViewController, animated: animated)
  }

  fileprivate func back(historyStack: HistoryStack, callBackItem: [String: QueryItem], navigationController: RootNavigationController, path: String, animated: Bool) {
    let currentViewControllers = navigationController.viewControllers.compactMap {
      $0 as? WrapperController
    }

    guard let pickViewController = currentViewControllers.first(where: { $0.key == path }) else { return }
    pickViewController.callbackCompletion?(callBackItem)
    navigationController.popToViewController(pickViewController, animated: animated)
  }

  func removePaths(
    historyStack: HistoryStack,
    navigationController: RootNavigationController,
    paths: [String],
    animated: Bool) {
    let newStack = historyStack.stack.filter { !paths.contains($0.key) }
    navigationController.setViewControllers(newStack.map(\.viewController), animated: animated)
  }

  fileprivate func href(
    historyStack: HistoryStack,
    navigationController: RootNavigationController,
    url: String,
    animated: Bool,
    didCompleted: @escaping ([ViewableRouter]) -> Void,
    errorAction: ((LinkNavigatorType, LinkNavigatorError) -> Void)?) {
    let currentViewControllers = navigationController.viewControllers.compactMap {
      $0 as? WrapperController
    }
    let newHistory = historyStack.reorderStack(viewControllers: currentViewControllers)
    guard let absURL = convertAbsolute(url: url, matches: newHistory.stack.map(\.matchURL)) else { return }
    guard let matchURL = MatchURL.serialized(url: absURL) else { return }

    do {
      let newStack = try routerGroup.build(
        history: newHistory,
        match: matchURL,
        environment: environment,
        navigator: self)

      didCompleted(newStack)
      navigationController.setViewControllers(newStack.map(\.viewController), animated: animated)
    } catch {
      errorAction?(self, .notFound)
    }
  }

  fileprivate func replace(historyStack: HistoryStack, navigationController: RootNavigationController, navigator: RootNavigator, url: String, didCompleted: @escaping ([ViewableRouter]) -> Void, errorAction: ((LinkNavigatorType, LinkNavigatorError) -> Void)?) -> RootNavigator {
    guard let matchURL = MatchURL.serialized(url: url) else {
      errorAction?(self, .notAllowedURL)
      return navigator
    }

    do {
      let newStack = try routerGroup.build(
        history: .init(),
        match: matchURL,
        environment: environment,
        navigator: self)

      navigationController.dismiss(animated: false) {
        didCompleted(newStack)
      }
    } catch {
      errorAction?(self, .notFound)
    }

    return navigator
  }

  fileprivate func isContain(navigationController: RootNavigationController, path: String) -> Bool {
    let currentViewControllers = navigationController.viewControllers.compactMap {
      $0 as? WrapperController
    }
    return currentViewControllers.first(where: { $0.key == path }) != .none
  }

  fileprivate func makeAbsoluteURL(paths: [String], queryItems: [String: QueryItemConvertable]) -> String {
    var queryParameter: String {
      guard !queryItems.isEmpty else { return "" }
      return "?\(queryItems.map{ "\($0.key)=\($0.value)" }.joined(separator: "&"))"
    }
    let path = paths.joined(separator: "/")
    return "\(defaultScheme)://\(path)\(convert(queryItems: queryItems))"
  }

  fileprivate func makeRelativeURL(paths: [String], queryItems: [String: QueryItemConvertable]) -> String {
    let path = paths.joined(separator: "/")
    return "/\(path)\(convert(queryItems: queryItems))"
  }

  fileprivate func convert(queryItems: [String: QueryItemConvertable]) -> String {
    guard !queryItems.isEmpty else { return "" }
    return "?\(queryItems.map{ "\($0.key)=\($0.value.serializedQueryItem().value)" }.joined(separator: "&"))"
  }

  fileprivate func clearSubNavigatorAndHistory() {
    subNavigationController.setViewControllers([], animated: false)
    subHistoryStack = subHistoryStack.mutate(stack: [])
  }

  fileprivate func removeBackPath(target: LinkTarget, path: String) {
    switch target {
    case .root:
      rootHistoryStack = rootHistoryStack.mutate(stack: rootHistoryStack.stack.reduce([]) { current, next in
        guard current.contains(where: { $0.key == path }) else { return current + [next] }
        return current
      })
    case .sheet, .sheetFull:
      subHistoryStack = subHistoryStack.mutate(stack: subHistoryStack.stack.reduce([]) { current, next in
        guard current.contains(where: { $0.key == path }) else { return current + [next] }
        return current
      })
    default:
      return
    }
  }
}

public struct RootNavigator: UIViewControllerRepresentable {

  let navigationController: UINavigationController

  public init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  public func makeUIViewController(context: Context) -> some UIViewController {
    navigationController
  }

  public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
  }
}

extension Array {
  subscript (safe index: Int) -> Element? {
    indices ~= index ? self[index] : .none
  }
}

extension UIViewController {
  func mutatedPresentationStyle(
    modalPresentationStyle: UIModalPresentationStyle = .automatic,
    modalTransitionStyle: UIModalTransitionStyle = .coverVertical) {
    self.modalPresentationStyle = modalPresentationStyle
    self.modalTransitionStyle = modalTransitionStyle
  }
}

#endif
