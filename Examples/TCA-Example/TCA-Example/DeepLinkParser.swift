import Foundation

struct LinkInfo: Equatable {
  let pathList: [String]
  let items: [String: String]
}

struct DeepLinkParser {
  static func parse(url: URL, completeAction: @escaping (LinkInfo?) -> Void) {
    guard let component = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
      completeAction(.none)
      return
    }

    let pathList = component.path.split(separator: "/").map(String.init)
    let queryItem: [String: String] = component.queryItems?.reduce([:]) { curr, next -> [String: String] in
      guard let value = next.value else { return curr }
      return curr.merging([next.name: value]) { $1 }
    } ?? [:]

    completeAction(.init(pathList: pathList, items: queryItem))
  }
}
