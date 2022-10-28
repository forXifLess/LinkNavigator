import SwiftUI

// MARK: - Page2

struct Page2View: IntentBindingType {
  @StateObject var container: Container<Page2IntentType, Page2Model.State>
  var intent: Page2IntentType { container.intent }
  var state: Page2Model.State { intent.state }
}

// MARK: View

extension Page2View: View {
  
  var body: some View {
    VStack(spacing: 40) {
      Text("2")
        .font(.system(size: 70, weight: .thin))

      NavigationStackViewer(paths: state.paths)
      
      Button(action: { intent.send(action: .onTapNext) }) {
        VStack {
          Text("go to next Page")
          Text("navigator.next(paths: [\"page3\"], items: [:], isAnimated: true)")
            .code()
        }
      }

      Button(action: { intent.send(action: .onTapRootPage3)}) {
        VStack {
          Text("**root** next")
          Text("navigator.rootNext(paths: [\"page3\"], items: [:], isAnimated: true)")
            .code()
        }
      }

      Button(action: { intent.send(action: .onRemovePage1) }) {
        VStack {
          Text("remove Page 1")
            .foregroundColor(.red)
          Text("navigator.remove(paths: [\"page1\"])")
            .code()
        }
      }

      Button(action: { intent.send(action: .onTapBack) }) {
        VStack {
          Text("back")
          Text("navigator.back(isAnimated: true)")
            .code()
        }
      }

      Spacer()
    }
    .padding(.horizontal)
    .navigationTitle("Page 2")
    .onAppear {
      intent.send(action: .getPaths)
    }
  }
}

extension Page2View {
  static func build(intent: Page2Intent) -> some View {
    Page2View(container: .init(
      intent: intent as Page2IntentType,
      state: intent.state,
      modelChangePublisher: intent.objectWillChange))
  }
}
