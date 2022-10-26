import ComposableArchitecture
import SwiftUI

public struct Page2View {
  private let store: StoreOf<Page2>
  @ObservedObject var viewStore: ViewStoreOf<Page2>

  public init(store: StoreOf<Page2>) {
    self.store = store
    viewStore = ViewStore(store)
  }
}

extension Page2View: View {
  public var body: some View {
    VStack(spacing: 40) {
      Text("2")
        .font(.system(size: 70, weight: .thin))

      NavigationStackViewer(paths: viewStore.paths)

      Button(action: { viewStore.send(.onTapNext) }) {
        VStack {
          Text("go to next Page")
          Text("navigator.next(paths: [\"page3\"], items: [:], isAnimated: true)")
            .font(.caption)
            .foregroundColor(.secondary)
        }
      }

      Button(action: { viewStore.send(.onTapRootPage3) }) {
        VStack {
          Text("**root** next")
          Text("navigator.rootNext(paths: [\"page3\"], items: [:], isAnimated: true)")
            .font(.caption)
            .foregroundColor(.secondary)
        }
      }

      Button(action: { viewStore.send(.onRemovePage1) }) {
        VStack {
          Text("remove Page 1")
            .foregroundColor(.red)
          Text("navigator.remove(paths: [\"page1\"])")
            .font(.caption)
            .foregroundColor(.secondary)
        }
      }

      Button(action: { viewStore.send(.onTapBack) }) {
        VStack {
          Text("back")
          Text("navigator.back(isAnimated: true)")
            .font(.caption)
            .foregroundColor(.secondary)
        }
      }

      Spacer()
    }
    .padding(.horizontal)
    .navigationTitle("Page 2")
    .onAppear {
      viewStore.send(.getPaths)
    }
  }
}
