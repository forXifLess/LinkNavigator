import Foundation
import LinkNavigator
import SwiftUI

struct SplashPage {
  let linkNavigator: LinkNavigatorProtocol & LinkNavigatorFindLocationUsable
}

extension SplashPage: View {
  var body: some View {
    VStack {
      Text("SplashPage")
    }
    .task {
      let _ = try? await Task.sleep(for: .seconds(2))
      linkNavigator.replace(
        linkItem: .init(path: AppLink.Path.dashboard.rawValue),
        isAnimated: true)
    }
  }
}
