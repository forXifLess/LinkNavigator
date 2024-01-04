import SwiftUI
import LinkNavigator

struct Step1Page: View {
  let navigator: RootNavigatorType
  @State var currentPath: String = ""
  @State var message: String = ""

  var nextTabPath: String {
    switch navigator.getCurrentPaths().first ?? "tab1" {
    case "tab1" : "tab2"
    case "tab2" : "tab3"
    case "tab3" : "tab4"
    case "tab4" : "tab1"
    default: "tab1"
    }
  }

  var body: some View {
    VStack(spacing: 16) {
      PathIndicator(currentPath: currentPath)
      .padding(.top, 32)

      TextField("Type message here", text: $message)
        .textFieldStyle(.roundedBorder)
        .padding(.horizontal)

      Spacer()

      Button(action: { navigator.next(linkItem: .init(
        path: "step2",
        items: Step2InjectionData(message: message).encoded()
      ), isAnimated: true) }) {
        Text("Next to 'Step2'")
      }

      Button(action: { navigator.close(isAnimated: true, completeAction: { }) }) {
        Text("Close Sheet")
      }

      Spacer()
    }
    .onAppear {
      currentPath = navigator.getCurrentPaths().joined(separator: " > ")
    }
  }
}

