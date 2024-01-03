import SwiftUI
import LinkNavigator

struct Step4Page: View {
  let navigator: RootNavigatorType
  @State var currentPath: String = ""

  var body: some View {
    VStack(spacing: 16) {
      PathIndicator(currentPath: currentPath)
      .padding(.top, 32)

      Spacer()

      Button(action: { navigator.sheet(linkItem: .init(path: "step1"), isAnimated: true) }) {
        Text("Open 'Step1' sheet")
      }

      Button(action: { navigator.back(isAnimated: true) }) {
        Text("Back")
      }

      Button(action: {
        navigator.remove(pathList: ["step2", "step3"])
        currentPath = navigator.getCurrentPaths().joined(separator: " > ")
      }) {
        Text("Remove path 'Step2, Step3'")
      }

      Button(action: { navigator.backOrNext(linkItem: .init(path: navigator.getCurrentRootPaths().first ?? ""), isAnimated: true) }) {
        Text("Back to root")
      }

      Spacer()
    }
    .onAppear {
      currentPath = navigator.getCurrentPaths().joined(separator: " > ")
    }
  }
}

