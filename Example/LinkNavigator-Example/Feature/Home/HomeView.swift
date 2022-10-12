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
    VStack(spacing: 40) {
      Text("Home")
        .font(.largeTitle)

      NavigationStackViewer(paths: state.paths)

      Button(action: { intent.send(action: .onTapPage1) }) {
        VStack {
          Text("go to next Page")
          Text("navigator.next(paths: [\"page1\"], items: [:], isAnimated: true)")
            .font(.caption)
            .foregroundColor(.secondary)
        }
      }

      Button(action: { intent.send(action: .onTapPage3)}) {
        VStack {
          Text("go to last Page")
          Text("navigator.next(paths: [\"page1\", \"page2\", \"page3\"], items: [:], isAnimated: true)")
            .font(.caption)
            .foregroundColor(.secondary)
        }
      }
      
      Button(action: { intent.send(action: .onTapSheet)}) {
        VStack {
          Text("open Page 2 as Sheet")
            .foregroundColor(.purple)
          Text("navigator.sheet(paths: [\"page1\", \"page2\"], items: [:], isAnimated: true)")
            .font(.caption)
            .foregroundColor(.secondary)
        }
      }

      Button(action: { intent.send(action: .onTapFullSheet)}) {
        VStack {
          Text("open Page 2 as Full Screen Sheet")
            .foregroundColor(.purple)
          Text("navigator.fullSheet(paths: [\"page1\", \"page2\"], items: [:], isAnimated: true)")
            .font(.caption)
            .foregroundColor(.secondary)
        }
      }
    }
    .padding(.horizontal)
    .navigationTitle("Home")
    .onAppear {
      intent.send(action: .getPaths)
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
