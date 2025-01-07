import LinkNavigator
import SwiftUI

struct Tab1Page: View {
  let navigator: TabPartialNavigator
  @State var currentPath = ""

  var body: some View {
    VStack(spacing: 16) {
      PathIndicator(currentPath: currentPath)
        .padding(.top, 32)

      Spacer()

      Button(action: { navigator.next(linkItem: .init(path: "step1"), isAnimated: true) }) {
        Text("Next to 'Step1'")
      }

      Spacer()
    }
    .onAppear {
      currentPath = navigator.getCurrentPaths().joined(separator: " > ")
    }
  }
}
