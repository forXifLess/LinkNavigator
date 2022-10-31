import ComposableArchitecture
import SwiftUI

public struct Page1View {
  private let store: StoreOf<Page1>
  @ObservedObject var viewStore: ViewStoreOf<Page1>

  public init(store: StoreOf<Page1>) {
    self.store = store
    viewStore = ViewStore(store)
  }
}

extension Page1View: View {
  public var body: some View {
    ScrollView {
      VStack(spacing: 40) {
        Text("1")
          .font(.system(size: 70, weight: .thin))

        NavigationStackViewer(paths: viewStore.paths)

        Button(action: { viewStore.send(.onTapNext) }) {
          VStack {
            Text("go to next Page")
            Text("navigator.next(paths: [\"page2\"], items: [:], isAnimated: true)")
              .code()
          }
        }

        Button(action: { viewStore.send(.onTapRandomBackOrNext) }) {
          VStack {
            Text("backOrNext")
            Text("navigator.backOrNext(path: Bool.random() ? \"home\" : \"page2\", items: [:], isAnimated: true)")
              .code()
          }
        }

        Button(action: { viewStore.send(.onTapRootRandomBackOrNext)} ) {
          VStack {
            Text("**root** backOrNext")
            Text("navigator.rootBackOrNext(path: Bool.random() ? \"home\" : \"page2\", items: [:], isAnimated: true)")
              .code()
          }
        }

        Button(action: { viewStore.send(.onTapBack)}) {
          VStack {
            Text("back")
            Text("navigator.back(isAnimated: true)")
              .code()
          }
        }

        Spacer()
      }
      .padding(.horizontal)
      .navigationTitle("Page 1")
      .onAppear {
        viewStore.send(.getPaths)
      }
    }
  }
}
