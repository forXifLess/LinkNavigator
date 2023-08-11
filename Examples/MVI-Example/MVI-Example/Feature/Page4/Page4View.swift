import SwiftUI

// MARK: - Page4View

struct Page4View: IntentBindingType {
  @StateObject var container: Container<Page4IntentType, Page4Model.State>
  var intent: Page4IntentType { container.intent }
  var state: Page4Model.State { intent.state }
}

// MARK: View

extension Page4View: View {
  var body: some View {
    ScrollView {
      VStack(spacing: 40) {
        Text("4")
          .font(.system(size: 70, weight: .thin))

        VStack {
          NavigationStackViewer(paths: state.paths)

          GroupBox {
            VStack(spacing: 10) {
              HStack {
                Image(systemName: "envelope")
                Text("Received Message")
              }
              .font(.footnote)
              .foregroundColor(.secondary)

              Text(state.message.isEmpty ? "-" : state.message)
            }
          }
        }

        Button(action: { intent.send(action: .onTapDeepLink) }) {
          VStack {
            Text("copy deep link")
              .foregroundColor(.green)
            Text("URL → mvi-ex://host/home/page1/page2/page3/page4?page3-message=world&page4-message=hello")
              .code()
          }
        }

        Button(action: { intent.send(action: .onTapBackToHome) }) {
          VStack {
            Text("back to Home")
            Text("navigator.backOrNext(path: \"home\", items: [:], isAnimated: true)")
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

        Button(action: { intent.send(action: .onTapReset) }) {
          VStack {
            Text("reset")
              .foregroundColor(.red)
            Text("navigator.replace(paths: [\"home\"], items: [:], isAnimated: true)")
              .code()
          }
        }

        Spacer()
      }
      .padding(.horizontal)
      .navigationTitle("Page 4")
      .onAppear {
        intent.send(action: .getPaths)
      }
    }
  }
}

extension Page4View {
  static func build(intent: Page4Intent) -> some View {
    Page4View(container: .init(
      intent: intent as Page4IntentType,
      state: intent.state,
      modelChangePublisher: intent.objectWillChange))
  }
}
