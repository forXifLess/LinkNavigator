import SwiftUI
import LinkNavigator

struct LoginView: View {

  let navigator: RootNavigatorType

  @State private var message: String = ""
  @State private var password: String = ""

  var body: some View {
    VStack(spacing: 30) {
      PathIndicator(currentPath: navigator.getCurrentPaths().joined(separator: " -> "))
        .padding(.top, 32)

      VStack(spacing: 16) {
        TextField("id", text: $message)
          .textFieldStyle(.roundedBorder)
          .padding(.horizontal)

        SecureField("password", text: $password)
          .textFieldStyle(.roundedBorder)
          .padding(.horizontal)

        Button(action: {
          UserDefaults.standard.setValue(true, forKey: "isLogin")
          navigator.close(isAnimated: true) {
            navigator.rootReloadLast(items: .init(path: "home"), isAnimated: true)
          }
        }) {
          Text("Login")
        }
      }
      Spacer()
    }
    .padding()
  }
}
