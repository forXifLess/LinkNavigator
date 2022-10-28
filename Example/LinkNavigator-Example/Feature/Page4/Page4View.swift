import SwiftUI

// MARK: - Page4

struct Page4View: IntentBindingType {
  @StateObject var container: Container<Page4IntentType, Page4Model.State>
  var intent: Page4IntentType { container.intent }
  var state: Page4Model.State { intent.state }
}

// MARK: View

extension Page4View: View {
  var body: some View {
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
            .foregroundColor(.teal)
          Text("URL → link-navigator-ex://home/page1/page2/page3/page4?message=message_from_deep_link")
            .code()
        }
      }

      Button(action: { intent.send(action: .onTapBackToHome)}) {
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

extension Page4View {
  static func build(intent: Page4Intent) -> some View {
    Page4View(container: .init(
      intent: intent as Page4IntentType,
      state: intent.state,
      modelChangePublisher: intent.objectWillChange))
  }
}
