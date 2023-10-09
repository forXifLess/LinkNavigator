import Foundation
import LinkNavigator
import SwiftUI

struct DashboardPage {
  @ObservedObject var viewModel: DashboardViewModel
  let linkNavigator: LinkNavigatorProtocol & LinkNavigatorFindLocationUsable
}

extension DashboardPage: View {
  var body: some View {
    VStack {
      Spacer()
      Text("is Login? \(viewModel.auth.isLogin ? "Yes" : "No")")

      Spacer()

      if viewModel.auth.isLogin {
        Button(action: {
          linkNavigator.sheet(linkItem: .init(path: AppLink.Path.setting.rawValue), isAnimated: true)
        }, label: {
          Text("Setting")
        })
      } else {
        Button(action: {
          linkNavigator.sheet(linkItem: .init(path: AppLink.Path.login.rawValue), isAnimated: true)
        }, label: {
          Text("Login")
        })
      }
    }
  }
}
