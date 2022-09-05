import SwiftUI

// MARK: - Page1

struct Page1: IntentBindingType {
  @StateObject var container: Container<Page1IntentType, Page1Model.State>
  var intent: Page1IntentType { container.intent }
  var state: Page1Model.State { intent.state }
}

// MARK: View

extension Page1: View {
  var body: some View {
    VStack(spacing: 40) {
      Text("Page 1")
        .font(.largeTitle)

      NavigationStackViewer(paths: state.paths)

      Button(action: { intent.send(action: .onTapPage2)}) {
        VStack {
          Text("go to next Page")
          Text("navigator.next(paths: [\"page2\"], items: [:], isAnimated: true)")
            .font(.caption)
            .foregroundColor(.secondary)
        }
      }

      Button(action: { intent.send(action: .onTapRandomBackOrNext) }) {
        VStack {
          Text("backOrNext")
          Text("navigator.backOrNext(path: Bool.random() ? \"home\" : \"page2\", items: [:], isAnimated: true)")
            .font(.caption)
            .foregroundColor(.secondary)
        }
      }

      Button(action: { intent.send(action: .onTapRootRandomBackOrNext)}) {
        VStack {
          Text("*root* backOrNext")
          Text("navigator.rootBackOrNext(path: Bool.random() ? \"home\" : \"page2\", items: [:], isAnimated: true)")
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
    .navigationTitle("Page 1")
    .onAppear {
      intent.send(action: .getPaths)
    }
  }
}

extension Page1 {
  static func build(intent: Page1Intent) -> some View {
    Page1(container: .init(
      intent: intent as Page1IntentType,
      state: intent.state,
      modelChangePublisher: intent.objectWillChange))
  }
}
