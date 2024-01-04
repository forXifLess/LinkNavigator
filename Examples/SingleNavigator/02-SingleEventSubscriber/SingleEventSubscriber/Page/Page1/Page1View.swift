import SwiftUI
import LinkNavigator

struct Page1View: View {

  let navigator: RootNavigatorType
  let item: HomeToPage1Item?

  var body: some View {
    ScrollView {
      VStack(spacing: 40) {
        Text("1")
          .font(.system(size: 70, weight: .thin))

        Text(navigator.getCurrentPaths().map { $0.replacingOccurrences(of: "page", with: "") }.joined(separator: " → "))

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
}

