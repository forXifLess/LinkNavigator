import SwiftUI
import LinkNavigator

struct Page1View: View {

  let navigator: RootNavigatorType

  var body: some View {
    ScrollView {
      VStack(spacing: 40) {
        Text("1")
          .font(.system(size: 70, weight: .thin))

        Text(navigator.getCurrentPaths().map { $0.replacingOccurrences(of: "page", with: "") }.joined(separator: " → "))
          .padding()

        Button(action: {
          navigator.next(linkItem: .init(path: "page2"), isAnimated: true)
        }) {
          Text("go to next Page")
        }

        Button(action: {
          navigator.backOrNext(linkItem: .init(path: Bool.random() ? "home" : "page2"), isAnimated: true)
        }) {
          Text("backOrNext")
        }

        Button(action: {
          navigator.rootBackOrNext(linkItem: .init(path: Bool.random() ? "home" : "page2"), isAnimated: true)
        }) {
          Text("**root** backOrNext")
        }

        Button(action: {
          navigator.back(isAnimated: true)
        }) {
          Text("back")
        }

        Button(action: {
          navigator.close(isAnimated: true, completeAction: { })
        }) {
          Text("close (only available in modal)")
            .foregroundColor(.red)
        }

        Spacer()
      }
      .padding()
    }
  }
}

