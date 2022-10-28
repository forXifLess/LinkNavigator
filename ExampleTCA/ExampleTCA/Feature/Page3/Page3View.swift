import ComposableArchitecture
import SwiftUI

public struct Page3View {
  private let store: StoreOf<Page3>
  @ObservedObject var viewStore: ViewStoreOf<Page3>

  public init(store: StoreOf<Page3>) {
    self.store = store
    viewStore = ViewStore(store)
  }
}

extension Page3View: View {
  public var body: some View {
    VStack(spacing: 40) {
      Text("3")
        .font(.system(size: 70, weight: .thin))

      NavigationStackViewer(paths: viewStore.paths)

      TextField("Type message here", text: viewStore.binding(\.$message))
        .textFieldStyle(.roundedBorder)
        .padding(.horizontal)

      Button(action: { viewStore.send(.onTapNextWithMessage) }) {
        VStack {
          Text("go to next Page with Message")
          Text("navigator.next(paths: [\"page4\"], items: [\"message\": messageYouTyped], isAnimated: true)")
            .code()
        }
      }

      Button(action: { viewStore.send(.onRemovePage1And2) }) {
        VStack {
          Text("remove Page 1 and 2")
            .foregroundColor(.red)
          Text("navigator.remove(paths: [\"page1\", \"page2\"])")
            .code()
        }
      }

      Button(action: { viewStore.send(.onTapBack) }) {
        VStack {
          Text("back")
          Text("navigator.back(isAnimated: true)")
            .code()
        }
      }

      Button(action: { viewStore.send(.onTapClose) }) {
        VStack {
          Text("close (only available in modal)")
            .foregroundColor(.red)
          Text("navigator.close { print(\"modal dismissed!\") }")
            .code()
        }
      }

      Spacer()
    }
    .padding(.horizontal)
    .navigationTitle("Page 3")
    .onAppear {
      viewStore.send(.getPaths)
    }
  }
}
