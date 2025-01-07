import LinkNavigator
import SwiftUI

struct Tab4Page: View {
  let navigator: TabPartialNavigator
  let eventSubscriber: EventSubscriber

  @State var currentPath = ""

  var body: some View {
    VStack(spacing: 16) {
      PathIndicator(currentPath: currentPath)
        .padding(.top, 32)

      Spacer()

      Button(action: { navigator.next(linkItem: .init(path: "step1"), isAnimated: true) }) {
        Text("Next to 'Step1'")
      }

      Button(action: {
        navigator.moveTab(path: "tab1")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
          navigator.send(
            targetTabPath: "tab1",
            linkItem: .init(
              path: "tab1",
              items: EventParam(action: .sendMessage("Message From \(navigator.getCurrentPaths().first ?? "-")"))))
        }
      }) {
        Text("Send event and move tab to 'tab1'")
      }

      Spacer()
    }
    .onReceive(eventSubscriber.action) { event in
      switch event.action {
      case .sendMessage(let message):
        navigator.backOrNext(
          linkItem: .init(pathList: ["step1", "step2"], items: Step2InjectionData(message: message)),
          isAnimated: true)
      }
    }
    .onAppear {
      currentPath = navigator.getCurrentPaths().joined(separator: " > ")
    }
  }
}
