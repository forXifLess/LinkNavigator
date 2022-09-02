import SwiftUI

// MARK: - Page3

struct Page3: IntentBindingType {
  @StateObject var container: Container<Page3IntentType, Page3Model.State>
  var intent: Page3IntentType { container.intent }
  var state: Page3Model.State { intent.state }
}

// MARK: View

extension Page3: View {
  var body: some View {
    VStack(spacing: 40) {
      Text("Page 3")
        .font(.largeTitle)
      
      GroupBox {
        Text(state.paths.joined(separator: " → "))
      }
      .padding(.horizontal)

      Button(action: { intent.send(action: .onTapBackOrNext) }) {
        VStack {
          Text("back to Home")
          Text("navigator.backOrNext(path: \"home\", items: [:], isAnimated: true)")
            .font(.caption)
            .foregroundColor(.secondary)
        }
      }

      Button(action: { intent.send(action: .onRemovePage1and2) }) {
        VStack {
          Text("remove Page 1 and 2")
            .foregroundColor(.red)
          Text("navigator.remove(paths: [\"page1\", \"page2\"])")
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

      Button(action: { intent.send(action: .onTapReset) }) {
        VStack {
          Text("reset")
            .foregroundColor(.red)
          Text("navigator.replace(paths: [\"home\"], items: [:], isAnimated: true)")
            .font(.caption)
            .foregroundColor(.secondary)
        }
      }
    }
    .navigationTitle("Page 3")
    .onAppear {
      intent.send(action: .getPaths)
    }
  }
}

extension Page3 {
  static func build(intent: Page3Intent) -> some View {
    Page3(container: .init(
      intent: intent as Page3IntentType,
      state: intent.state,
      modelChangePublisher: intent.objectWillChange))
  }
}
