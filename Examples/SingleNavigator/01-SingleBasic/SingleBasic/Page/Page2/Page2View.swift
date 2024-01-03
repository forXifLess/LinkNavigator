import SwiftUI
import LinkNavigator

struct Page2View: View {

  let navigator: RootNavigatorType
  @State private var paths: [String] = []

  var body: some View {
    ScrollView {
      VStack(spacing: 40) {
        Text("2")
          .font(.system(size: 70, weight: .thin))

        Text(paths.map { $0.replacingOccurrences(of: "page", with: "") }.joined(separator: " → "))
          .padding()

        Button(action: {
          navigator.next(linkItem: .init(path: "page3"), isAnimated: true)
        }) {
          Text("go to next Page")
        }

        Button(action: { 
          navigator.rootNext(linkItem: .init(path: "page3"), isAnimated: true)
        }) {
          Text("**root** next")
        }

        Button(action: {
          navigator.remove(pathList: ["page1"])
          paths = navigator.getCurrentPaths()
        }) {
          Text("remove Page 1")
            .foregroundColor(.red)
        }

        Button(action: {
          navigator.back(isAnimated: true)
        }) {
          Text("back")
        }

        Spacer()
      }
      .padding()
      .onAppear {
        paths = navigator.getCurrentPaths()
      }
    }
  }
}
