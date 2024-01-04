import Foundation
import LinkNavigator

enum DeepLinkParser {
  static func parse(url: URL, completeAction: @escaping (LinkItem?) -> Void) {
    guard let component = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
      completeAction(.none)
      return
    }

    let pathList = component.path.split(separator: "/").map(String.init)
    let item: String = component.query ?? ""
    completeAction(.init(pathList: pathList, items: item))
  }
}
