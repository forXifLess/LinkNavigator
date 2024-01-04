import SwiftUI
import LinkNavigator

struct Page3View: View {

  let navigator: RootNavigatorType
  @State var message: String = ""

  var body: some View {
    ScrollView {
      VStack(spacing: 40) {
        Text("3")
          .font(.system(size: 70, weight: .thin))

        Text(navigator.getCurrentPaths().map { $0.replacingOccurrences(of: "page", with: "") }.joined(separator: " → "))

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
}
extension Page3View {
  struct Page2InjectionData: Equatable, Codable {
    let message: String
  }
}

