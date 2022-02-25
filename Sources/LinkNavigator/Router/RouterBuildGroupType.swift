import Foundation

public protocol RouterBuildGroupType {
  var builders: [RouteBuildeableType] { get }
  func build(history: HistoryStack, match: MatchURL, enviroment: EnviromentType,  navigator: LinkNavigator) throws -> [ViewableRouter]
}

extension RouterBuildGroupType {
  public func build(history: HistoryStack, match: MatchURL, enviroment: EnviromentType,  navigator: LinkNavigator) throws -> [ViewableRouter] {
    let result = try match.pathes.map {
      try $0.getOrNewBuild(
        history: history,
        match: match,
        enviroment: enviroment,
        builders: builders,
        navigator: navigator)
    }
    return result
  }
}

extension String {
  fileprivate func getOrNewBuild(history: HistoryStack, match: MatchURL, enviroment: EnviromentType, builders: [RouteBuildeableType], navigator: LinkNavigator) throws -> ViewableRouter {
    guard let pickBuilder = builders.first(where: { $0.matchPath == self }) else { throw LinkNavigatorError.notFound }

    return history.stack.first(where: { $0.key == self }) ?? pickBuilder.build(enviroment, self, match, navigator)

  }
}
