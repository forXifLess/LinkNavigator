import SwiftUI

// MARK: - HomeView

struct HomeView: IntentBindingType {
  @StateObject var container: Container<HomeIntentType, HomeModel.State>
  var intent: HomeIntentType { container.intent }
  var state: HomeModel.State { intent.state }
}

// MARK: View

extension HomeView: View {
  var body: some View {
    ScrollView {
      VStack(spacing: 40) {
        NavigationStackViewer(paths: state.paths)

        Button(action: { intent.send(action: .onTapNext) }) {
          VStack {
            Text("go to next Page")
            Text("navigator.next(paths: [\"page1\"], items: [:], isAnimated: true)")
              .code()
          }
        }

        Button(action: { intent.send(action: .onTapPage3)}) {
          VStack {
            Text("go to last Page")
            Text("navigator.next(paths: [\"page1\", \"page2\", \"page3\"], items: [:], isAnimated: true)")
              .code()
          }
        }

        Button(action: { intent.send(action: .onTapAlert) }) {
          VStack {
            Text("show alert")
              .foregroundColor(.orange)
            Text("navigator.alert(target: .default, model: alertModel)")
              .code()
          }
        }

        Button(action: { intent.send(action: .onTapSheet)}) {
          VStack {
            Text("open Page 2 as Sheet")
              .foregroundColor(.purple)
            Text("navigator.sheet(paths: [\"page1\", \"page2\"], items: [:], isAnimated: true)")
              .code()
          }
        }

        Button(action: { intent.send(action: .onTapFullSheet)}) {
          VStack {
            Text("open Page 2 as Full Screen Sheet")
              .foregroundColor(.purple)
            Text("navigator.fullSheet(paths: [\"page1\", \"page2\"], items: [:], isAnimated: true, prefersLargeTitles: true)")
              .code()
          }
        }

        Spacer()
      }
      .padding(.horizontal)
      .navigationBarTitleDisplayMode(.large)
      .navigationTitle("Home")
      .onAppear {
        intent.send(action: .getPaths)
      }
    }
  }
}

extension HomeView {
  static func build(intent: HomeIntent) -> some View {
    HomeView(container: .init(
      intent: intent as HomeIntentType,
      state: intent.state,
      modelChangePublisher: intent.objectWillChange))
  }
}
