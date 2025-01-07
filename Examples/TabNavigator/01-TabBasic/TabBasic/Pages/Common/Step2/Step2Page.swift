import LinkNavigator
import SwiftUI

struct Step2Page: View {
  let navigator: TabPartialNavigator
  @State var currentPath = ""

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
