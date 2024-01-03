import SwiftUI
import LinkNavigator

struct HomeView: View {

  let navigator: RootNavigatorType

  var body: some View {
    ScrollView {
      VStack(spacing: 40) {
        Button(action: {
          navigator.backOrNext(linkItem: .init(path: "page1"), isAnimated: true)
        }) {
          VStack {
            Text("go to next Page")
            Text("navigator.next(paths: [\"page1\"], items: [:], isAnimated: true)")
              .font(.caption)
              .foregroundColor(.secondary)
          }
        }

        Button(action: {
          navigator.backOrNext(linkItem: .init(pathList: ["page1", "page2", "page3"]), isAnimated: true)
        }) {
          VStack {
            Text("go to last Page")
            Text("navigator.next(paths: [\"page1\", \"page2\", \"page3\"], items: [:], isAnimated: true)")
              .font(.caption)
              .foregroundColor(.secondary)
          }
        }

        Button(action: {
          let alertModel = Alert(
            title: "Title",
            message: "message",
            buttons: [.init(title: "OK", style: .default, action: { print("OK tapped") })],
            flagType: .default)
          navigator.alert(target: .default, model: alertModel)
        }) {
          VStack {
            Text("show alert")
              .foregroundColor(.orange)
            Text("navigator.alert(target: .default, model: alertModel)")
              .font(.caption)
              .foregroundColor(.secondary)
          }
        }

        Button(action: {
          navigator.sheet(linkItem: .init(pathList: ["page1", "page2"]), isAnimated: true)
        }) {
          VStack {
            Text("open Page 2 as Sheet")
              .foregroundColor(.purple)
            Text("navigator.sheet(paths: [\"page1\", \"page2\"], items: [:], isAnimated: true)")
              .font(.caption)
              .foregroundColor(.secondary)
          }
        }

        Button(action: {
          navigator.fullSheet(linkItem: .init(pathList: ["page1", "page2"]), isAnimated: true, prefersLargeTitles: true)
        }) {
          VStack {
            Text("open Page 2 as Full Screen Sheet")
              .foregroundColor(.purple)
            Text("navigator.fullSheet(paths: [\"page1\", \"page2\"], items: [:], isAnimated: true, prefersLargeTitles: true)")
              .font(.caption)
              .foregroundColor(.secondary)
          }
        }

        Spacer()
      }
      .padding(.horizontal)
      .navigationBarTitleDisplayMode(.large)
      .navigationTitle("Home")
    }
  }
}
