import SwiftUI
import LinkNavigator

struct Step1Page: View {
  let navigator: RootNavigatorType
  @State var currentPath: String = ""

  var body: some View {
    VStack(spacing: 16) {
      PathIndicator(currentPath: currentPath)
      .padding(.top, 32)

      Spacer()

      Button(action: { navigator.next(linkItem: .init(path: "step2"), isAnimated: true) }) {
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
