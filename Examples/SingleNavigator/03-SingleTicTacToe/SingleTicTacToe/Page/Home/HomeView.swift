import LinkNavigator
import SwiftUI

struct HomeView: View {

  // MARK: Internal

  let navigator: SingleLinkNavigator

  var body: some View {
    VStack(spacing: 30) {
      PathIndicator(currentPath: navigator.getCurrentPaths().joined(separator: " -> "))
        .padding(.top, 32)

      Button(action: {
        navigator.sheet(linkItem: .init(path: "login"), isAnimated: true)
      }) {
        Text("go to Login")
      }

      Spacer()
    }
    .padding()
    .onAppear {
      if isLogin {
        navigator.replace(linkItem: .init(path: "newGame"), isAnimated: true)
      }
    }
  }

  // MARK: Private

  @State private var isLogin = UserDefaults.standard.bool(forKey: "isLogin")

}
