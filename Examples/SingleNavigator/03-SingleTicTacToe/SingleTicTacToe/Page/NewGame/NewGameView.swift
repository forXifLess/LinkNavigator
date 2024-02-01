import LinkNavigator
import SwiftUI

struct NewGameView: View {

  let navigator: RootNavigatorType
  @State var gameTitle = ""

  var body: some View {
    VStack(spacing: 30) {
      PathIndicator(currentPath: navigator.getCurrentPaths().joined(separator: " -> "))
        .padding(.top, 32)

      VStack(spacing: 16) {
        Text("새로운 게임 생성")
        TextField("Type message here", text: $gameTitle)
          .textFieldStyle(.roundedBorder)
          .padding(.horizontal)

        Button(action: {
          navigator.next(
            linkItem: .init(
              path: "game",
              items: GameInjectionData(gameTitle: gameTitle).encoded()),
            isAnimated: true)
        }) {
          Text("게임 시작")
        }
      }

      Spacer()

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
