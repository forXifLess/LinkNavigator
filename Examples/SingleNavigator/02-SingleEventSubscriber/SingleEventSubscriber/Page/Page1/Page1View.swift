import LinkNavigator
import SwiftUI

struct Page1View: View {

  let navigator: RootNavigatorType
  let item: HomeToPage1Item?
  let deepLinkItem: DeepLinkItem?

  var body: some View {
    VStack(spacing: 30) {
      PathIndicator(currentPath: navigator.getCurrentPaths().joined(separator: " -> "))
        .padding(.top, 32)

      GroupBox {
        VStack(spacing: 10) {
          HStack {
            Image(systemName: "envelope")
            Text("HomePage Received Message")
          }
          .font(.footnote)
          .foregroundColor(.secondary)

          Text(item?.message ?? "-")
        }
      }

      GroupBox {
        VStack(spacing: 10) {
          HStack {
            Image(systemName: "envelope")
            Text("DeepLink Received Message")
          }
          .font(.footnote)
          .foregroundColor(.secondary)

          Text(deepLinkItem?.deepLinkMessage ?? "-")
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
