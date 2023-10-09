import Foundation
import LinkNavigator
import SwiftUI

struct LoginPage {
  let linkNavigator: LinkNavigatorProtocol & LinkNavigatorFindLocationUsable
}

extension LoginPage: View {
  var body: some View {
    VStack {
      Text("LoginPage")

      Spacer()

      Button(action: {
        linkNavigator.rootSend(item: .init(
          path: AppLink.Path.dashboard.rawValue,
          items: AuthenticationModel(isLogin: true).encoded()))
        linkNavigator.close(isAnimated: true, completeAction: {})
      }, label: {
        Text("Login")
      })
    }
  }
}
