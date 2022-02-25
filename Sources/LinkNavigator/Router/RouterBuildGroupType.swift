import Foundation

public protocol RouterBuildGroupType {
  var builders: [RouteBuildeableType] { get }
  func build(history: HistoryStack, match: MatchURL, enviroment: EnviromentType,  navigator: LinkNavigator) -> [ViewableRouter]
}

extension RouterBuildGroupType {
  public func build(history: HistoryStack, match: MatchURL, enviroment: EnviromentType,  navigator: LinkNavigator) -> [ViewableRouter] {
    match.pathes.map {
      $0.getOrNewBuild(
        history: history,
        match: match,
        enviroment: enviroment,
        builders: builders,
        navigator: navigator)
    }
  }
}

extension String {
  fileprivate func getOrNewBuild(history: HistoryStack, match: MatchURL, enviroment: EnviromentType, builders: [RouteBuildeableType], navigator: LinkNavigator) -> ViewableRouter {
    guard let pickBuilder = builders.first(where: { $0.matchPath == self }) else { return .emptyView() }

    return history.stack.first(where: { $0.key == self }) ?? pickBuilder.build(enviroment, self, match, navigator)

  }
}
