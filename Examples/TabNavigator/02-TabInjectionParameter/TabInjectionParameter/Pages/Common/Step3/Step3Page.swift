import SwiftUI
import LinkNavigator

struct Step3Page: View {
  let navigator: RootNavigatorType
  @State var currentPath: String = ""

  var body: some View {
    VStack(spacing: 16) {
      PathIndicator(currentPath: currentPath)
      .padding(.top, 32)

      Spacer()

      Button(action: { navigator.next(linkItem: .init(path: "step4"), isAnimated: true) }) {
        Text("Next to 'Step4'")
      }

      Button(action: { 
        navigator.rootReloadLast(linkItem: .init(path: "step2", items: Step2InjectionData(message: "Replaced message!")), isAnimated: true) }) {
        Text("Replaced 'Step3' message")
      }

      Button(action: { navigator.back(isAnimated: true) }) {
        Text("Back")
      }

      Spacer()
    }
    .onAppear {
      currentPath = navigator.getCurrentPaths().joined(separator: " > ")
    }
  }
}
