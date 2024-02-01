import LinkNavigator
import SwiftUI

struct Page1View: View {

  // MARK: Internal

  let navigator: RootNavigatorType

  var body: some View {
    VStack(spacing: 30) {
      PathIndicator(currentPath: paths.joined(separator: " -> "))
        .padding(.top, 32)

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
    .onAppear {
      paths = navigator.getCurrentPaths()
    }
  }

  // MARK: Private

  @State private var paths: [String] = []

}
