import LinkNavigator
import SwiftUI

// MARK: - HomeView

struct HomeView: View {

  let navigator: RootNavigatorType
  @State var message = ""

  var body: some View {
    VStack(spacing: 30) {
      PathIndicator(currentPath: navigator.getCurrentPaths().joined(separator: " -> "))
        .padding(.top, 32)

      VStack(spacing: 16) {
        TextField("Type message here", text: $message)
          .textFieldStyle(.roundedBorder)
          .padding(.horizontal)

        Button(action: {
          navigator.backOrNext(
            linkItem: .init(
              path: "page1",
              items: HomeToPage1Item(message: message).encoded()),
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

// MARK: - HomeToPage1Item

struct HomeToPage1Item: Equatable, Codable {
  let message: String
}
