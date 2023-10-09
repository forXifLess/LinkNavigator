import Foundation
import LinkNavigator
import SwiftUI

struct SettingPage {
  let linkNavigator: LinkNavigatorProtocol & LinkNavigatorFindLocationUsable
}

extension SettingPage: View {
  var body: some View {
    VStack {
      Text("SettingPage")

      Spacer()

      Button(action: {
        linkNavigator.rootSend(item: .init(
          path: AppLink.Path.dashboard.rawValue,
          items: AuthenticationModel(isLogin: false).encoded()))
        linkNavigator.close(isAnimated: true, completeAction: {})
      }, label: {
        Text("LogOut")
      })
    }
  }
}
