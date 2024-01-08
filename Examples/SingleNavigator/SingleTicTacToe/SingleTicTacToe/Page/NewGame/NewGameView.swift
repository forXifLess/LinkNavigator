import SwiftUI
import LinkNavigator

struct NewGameView: View {

  let navigator: RootNavigatorType

  var body: some View {
    VStack(spacing: 30) {
      PathIndicator(currentPath: navigator.getCurrentPaths().joined(separator: " -> "))
        .padding(.top, 32)

      Button(action: {
        UserDefaults.standard.setValue(false, forKey: "isLogin")
        navigator.replace(linkItem: .init(path: "home"), isAnimated: true)
      }) {
        Text("logout")
      }

      Spacer()
    }
    .padding()
  }
}
