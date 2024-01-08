import SwiftUI
import LinkNavigator

struct HomeView: View {

  let navigator: RootNavigatorType

  @State private var isLogin = UserDefaults.standard.bool(forKey: "isLogin")

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
}
