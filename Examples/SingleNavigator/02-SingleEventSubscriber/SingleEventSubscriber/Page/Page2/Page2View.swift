import SwiftUI
import LinkNavigator

struct Page2View: View {

  private let navigator: RootNavigatorType
  @ObservedObject private var linkSubscriber: Page2LinkSubscriber

  init(
    navigator: RootNavigatorType,
    linkSubscriber: Page2LinkSubscriber)
  {
    self.navigator = navigator
    self.linkSubscriber = linkSubscriber
  }

  var body: some View {
    ScrollView {
      VStack(spacing: 40) {
        Text("2")
          .font(.system(size: 70, weight: .thin))

        Text(navigator.getCurrentPaths().map { $0.replacingOccurrences(of: "page", with: "") }.joined(separator: " → "))

        Button(action: {
          navigator.backOrNext(linkItem: .init(path: "page3"), isAnimated: true)
        }) {
          Text("go to next Page")
        }

        GroupBox {
          VStack(spacing: 10) {
            HStack {
              Image(systemName: "envelope")
              Text("page3 event handler")
            }
            .font(.footnote)
            .foregroundColor(.secondary)

            Text(linkSubscriber.linkAction?.message ?? "-")
          }
        }

        Spacer()
      }
      .padding()
    }
  }
}
