import SwiftUI
import LinkNavigator

struct Step2Page: View {
  let navigator: RootNavigatorType
  @State var currentPath: String = ""

  var body: some View {
    VStack(spacing: 16) {
      PathIndicator(currentPath: currentPath)
      .padding(.top, 32)

      Spacer()

      Button(action: { navigator.next(linkItem: .init(path: "step3"), isAnimated: true) }) {
        Text("Next to 'Step3'")
      }

      Button(action: { navigator.fullSheet(linkItem: .init(path: "step1"), isAnimated: true, prefersLargeTitles: false) }) {
        Text("Open Full-Sheet 'Step1'")
      }

      Button(action: { navigator.close(isAnimated: true, completeAction: { }) }) {
        Text("Close Sheet")
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
