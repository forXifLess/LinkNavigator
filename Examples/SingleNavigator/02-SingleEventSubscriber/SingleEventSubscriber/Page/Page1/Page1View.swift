import SwiftUI
import LinkNavigator

struct Page1View: View {

  let navigator: RootNavigatorType
  let item: HomeToPage1Item?

  var body: some View {
    VStack(spacing: 30) {
      PathIndicator(currentPath: navigator.getCurrentPaths().joined(separator: " -> "))
        .padding(.top, 32)

      GroupBox {
        VStack(spacing: 10) {
          HStack {
            Image(systemName: "envelope")
            Text("Received Message")
          }
          .font(.footnote)
          .foregroundColor(.secondary)

          Text(item?.message ?? "-")
        }
      }

      Button(action: {
        navigator.backOrNext(linkItem: .init(path: "page2"), isAnimated: true)
      }) {
        Text("go to next Page")
      }

      Spacer()
    }
    .padding()
  }
}

