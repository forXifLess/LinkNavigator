import LinkNavigator
import SwiftUI

struct HomeView: View {

  // MARK: Internal

  let navigator: RootNavigatorType

  var body: some View {
    VStack(spacing: 30) {
      PathIndicator(currentPath: paths.joined(separator: " -> "))
        .padding(.top, 32)

      Button(action: {
        navigator.backOrNext(linkItem: .init(path: "page1"), isAnimated: true)
      }) {
        Text("go to next Page")
      }

      Button(action: {
        navigator.backOrNext(linkItem: .init(pathList: ["page1", "page2", "page3"]), isAnimated: true)
      }) {
        Text("go to last Page")
      }

      Button(action: {
        let alertModel = Alert(
          title: "Title",
          message: "message",
          buttons: [.init(title: "OK", style: .default, action: { LogManager.default.debug("OK Tapped") })],
          flagType: .default)
        navigator.alert(target: .default, model: alertModel)
      }) {
        Text("show alert")
          .foregroundColor(.orange)
      }

      Button(action: {
        navigator.sheet(linkItem: .init(pathList: ["page1", "page2"]), isAnimated: true)
      }) {
        Text("open Page 2 as Sheet")
          .foregroundColor(.purple)
      }

      Button(action: {
        navigator.fullSheet(linkItem: .init(pathList: ["page1", "page2"]), isAnimated: true, prefersLargeTitles: true)
      }) {
        Text("open Page 2 as Full Screen Sheet")
          .foregroundColor(.purple)
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
