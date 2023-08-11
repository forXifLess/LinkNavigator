import SwiftUI

// MARK: - Page1View

struct Page1View: IntentBindingType {
  @StateObject var container: Container<Page1IntentType, Page1Model.State>
  var intent: Page1IntentType { container.intent }
  var state: Page1Model.State { intent.state }
}

// MARK: View

extension Page1View: View {

  var body: some View {
    ScrollView {
      VStack(spacing: 40) {
        Text("1")
          .font(.system(size: 70, weight: .thin))

        NavigationStackViewer(paths: state.paths)

        Button(action: { intent.send(action: .onTapNext) }) {
          VStack {
            Text("go to next Page")
            Text("navigator.next(paths: [\"page2\"], items: [:], isAnimated: true)")
              .code()
          }
        }

        Button(action: { intent.send(action: .onTapRandomBackOrNext) }) {
          VStack {
            Text("backOrNext")
            Text("navigator.backOrNext(path: Bool.random() ? \"home\" : \"page2\", items: [:], isAnimated: true)")
              .code()
          }
        }

        Button(action: { intent.send(action: .onTapRootRandomBackOrNext) }) {
          VStack {
            Text("**root** backOrNext")
            Text("navigator.rootBackOrNext(path: Bool.random() ? \"home\" : \"page2\", items: [:], isAnimated: true)")
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
      .navigationTitle("Page 1")
      .onAppear {
        intent.send(action: .getPaths)
      }
    }
  }
}

extension Page1View {
  static func build(intent: Page1Intent) -> some View {
    Page1View(container: .init(
      intent: intent as Page1IntentType,
      state: intent.state,
      modelChangePublisher: intent.objectWillChange))
  }
}
