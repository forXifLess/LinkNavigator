import LinkNavigator
import SwiftUI

struct Tab2Page: View {
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
        navigator.moveTab(path: "tab3")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
          navigator.send(
            targetTabPath: "tab3",
            linkItem: .init(
              path: "tab3",
              items: EventParam(action: .sendMessage("Message From \(navigator.getCurrentPaths().first ?? "-")"))))
        }
      }) {
        Text("Send event and move tab to 'tab3'")
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
      currentPath = navigator.getCurrentPaths().joined(separator: " -> ")
    }
  }
}
