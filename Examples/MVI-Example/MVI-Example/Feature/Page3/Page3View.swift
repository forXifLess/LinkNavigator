import SwiftUI

// MARK: - Page3

struct Page3View: IntentBindingType {
  @StateObject var container: Container<Page3IntentType, Page3Model.State>
  var intent: Page3IntentType { container.intent }
  var state: Page3Model.State { intent.state }
}

extension Page3View {
  var messageBinding: Binding<String> {
    .init(get: { state.message }, set: { intent.send(action: .onChangeMessage($0)) })
  }
}

// MARK: View

extension Page3View: View {
  var body: some View {
    ScrollView {
      VStack(spacing: 40) {
        Text("3")
          .font(.system(size: 70, weight: .thin))

        NavigationStackViewer(paths: state.paths)

        TextField("Type message here", text: messageBinding)
          .textFieldStyle(.roundedBorder)
          .padding(.horizontal)

        Button(action: { intent.send(action: .onTapNextWithMessage) }) {
          VStack {
            Text("go to next Page with Message")
            Text("navigator.next(paths: [\"page4\"], items: [\"message\": messageYouTyped], isAnimated: true)")
              .code()
          }
        }

        Button(action: { intent.send(action: .onRemovePage1and2) }) {
          VStack {
            Text("remove Page 1 and 2")
              .foregroundColor(.red)
            Text("navigator.remove(paths: [\"page1\", \"page2\"])")
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

        Button(action: { intent.send(action: .onTapClose) }) {
          VStack {
            Text("close (only available in modal)")
              .foregroundColor(.red)
            Text("navigator.close { print(\"modal dismissed!\") }")
              .code()
          }
        }

        Spacer()
      }
      .padding(.horizontal)
      .navigationTitle("Page 3")
      .onAppear {
        intent.send(action: .getPaths)
      }
    }
  }
}

extension Page3View {
  static func build(intent: Page3Intent) -> some View {
    Page3View(container: .init(
      intent: intent as Page3IntentType,
      state: intent.state,
      modelChangePublisher: intent.objectWillChange))
  }
}
