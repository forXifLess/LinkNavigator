import SwiftUI
import LinkNavigator

struct Page3View: View {

  let navigator: RootNavigatorType
  @State private var paths: [String] = []

  var body: some View {
    VStack(spacing: 30) {
      PathIndicator(currentPath: paths.joined(separator: " -> "))
        .padding(.top, 32)

      Button(action: {
        navigator.next(linkItem: .init(path: "page4"), isAnimated: true)
      }) {
        Text("go to next Page")
      }

      Button(action: {
        navigator.remove(pathList: ["page1", "page2"])
        paths = navigator.getCurrentPaths()
      }) {
        Text("remove Page 1 and 2")
          .foregroundColor(.red)
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
}

