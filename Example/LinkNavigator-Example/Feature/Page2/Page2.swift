import SwiftUI

// MARK: - Page2

struct Page2: IntentBindingType {
  @StateObject var container: Container<Page2IntentType, Page2Model.State>
  var intent: Page2IntentType { container.intent }
  var state: Page2Model.State { intent.state }
}

// MARK: View

extension Page2: View {
  var body: some View {
    VStack(spacing: 40) {
      Text("Page 2")
        .font(.largeTitle)

      NavigationStackViewer(paths: state.paths)
      
      Button(action: { intent.send(action: .onTapPage3) }) {
        VStack {
          Text("go to next Page")
          Text("navigator.next(paths: [\"page3\"], items: [:], isAnimated: true)")
            .font(.caption)
            .foregroundColor(.secondary)
        }
      }

      Button(action: { intent.send(action: .onTapRootPage3)}) {
        VStack {
          Text("*root* next")
          Text("navigator.rootNext(paths: [\"page3\"], items: [:], isAnimated: true)")
            .font(.caption)
            .foregroundColor(.secondary)
        }
      }

      Button(action: { intent.send(action: .onRemovePage1) }) {
        VStack {
          Text("remove Page 1")
            .foregroundColor(.red)
          Text("navigator.remove(paths: [\"page1\"])")
            .font(.caption)
            .foregroundColor(.secondary)
        }
      }

      Button(action: { intent.send(action: .onTapBack) }) {
        VStack {
          Text("back")
          Text("navigator.back(isAnimated: true)")
            .font(.caption)
            .foregroundColor(.secondary)
        }
      }
    }
    .padding(.horizontal)
    .navigationTitle("Page 2")
    .onAppear {
      intent.send(action: .getPaths)
    }
  }
}

extension Page2 {
  static func build(intent: Page2Intent) -> some View {
    Page2(container: .init(
      intent: intent as Page2IntentType,
      state: intent.state,
      modelChangePublisher: intent.objectWillChange))
  }
}
