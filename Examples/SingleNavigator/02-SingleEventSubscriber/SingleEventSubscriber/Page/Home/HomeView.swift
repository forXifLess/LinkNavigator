import SwiftUI
import LinkNavigator

struct HomeView: View {

  let navigator: RootNavigatorType
  @State var message: String = ""

  var body: some View {
    ScrollView {
      VStack(spacing: 40) {

        VStack(spacing: 16) {
          TextField("Type message here", text: $message)
            .textFieldStyle(.roundedBorder)
            .padding(.horizontal)

          Button(action: {
            navigator.backOrNext(
              linkItem: .init(
                path: "page1",
                items: HomeToPage1Item(message: message).encoded()
              ),
              isAnimated: true)
          }) {
            Text("go to next Page with Message")
          }
        }

        Button(action: {
          navigator.backOrNext(linkItem: .init(path: "page1"), isAnimated: true)
        }) {
          Text("go to next Page")
        }

        Spacer()
      }
      .padding()
    }
  }
}

struct HomeToPage1Item: Equatable, Codable {
  let message: String
}
