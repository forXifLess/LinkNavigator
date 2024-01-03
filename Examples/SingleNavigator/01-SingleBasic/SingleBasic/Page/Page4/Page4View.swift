import SwiftUI
import LinkNavigator

struct Page4View: View {

  let navigator: RootNavigatorType

  var body: some View {
    ScrollView {
      VStack(spacing: 40) {
        Text("4")
          .font(.system(size: 70, weight: .thin))

        Text(navigator.getCurrentPaths().map { $0.replacingOccurrences(of: "page", with: "") }.joined(separator: " → "))
          .padding()

        Button(action: {
          navigator.backOrNext(linkItem: .init(path: "home"), isAnimated: true)
        }) {
          Text("back to Home")
        }

        Button(action: {
          navigator.back(isAnimated: true)
        }) {
          Text("back")
        }

        Button(action: {
          navigator.replace(linkItem: .init(path: "home"), isAnimated: false)
        }) {
          Text("reset")
            .foregroundColor(.red)
        }

        Spacer()
      }
      .padding()
    }
  }
}
