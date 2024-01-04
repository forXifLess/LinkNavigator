import SwiftUI
import LinkNavigator

struct Page3View: View {

  let navigator: RootNavigatorType
  @State var message: String = ""

  var body: some View {
    VStack(spacing: 30) {
      PathIndicator(currentPath: navigator.getCurrentPaths().joined(separator: " -> "))
        .padding(.top, 32)

      VStack(spacing: 16) {
        TextField("Type message here", text: $message)
          .textFieldStyle(.roundedBorder)
          .padding(.horizontal)

        Button(action: {
          navigator.rootSend(
            item: .init(
              path: "page2",
              items: Page2InjectionData(message: message).encoded()
            )
          )
          navigator.back(isAnimated: true)

        }) {
          Text("back with Message")
        }
      }

      Spacer()

    }
    .padding()
  }
}
extension Page3View {
  struct Page2InjectionData: Equatable, Codable {
    let message: String
  }
}

