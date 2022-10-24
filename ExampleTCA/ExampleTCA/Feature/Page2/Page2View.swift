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
      Text("Page 1")
        .font(.largeTitle)

      NavigationStackViewer(paths: viewStore.rootPath)
      NavigationStackViewer(paths: viewStore.subPath)

      Button(action: { viewStore.send(.onTapPage3) }) {
        VStack {
          Text("go to next Page")
          Text("navigator.next(paths: [\"page2\"], items: [:], isAnimated: true)")
            .font(.caption)
            .foregroundColor(.secondary)
        }
      }

      Button(action: { viewStore.send(.onTapRootPage3) }) {
        VStack {
          Text("backOrNext")
          Text("navigator.backOrNext(path: Bool.random() ? \"home\" : \"page2\", items: [:], isAnimated: true)")
            .font(.caption)
            .foregroundColor(.secondary)
        }
      }

      Button(action: { viewStore.send(.onRemovePage1) }) {
        VStack {
          Text("**root** backOrNext")
          Text("navigator.rootBackOrNext(path: Bool.random() ? \"home\" : \"page2\", items: [:], isAnimated: true)")
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
    }
    .padding(.horizontal)
    .navigationTitle("Page 1")
    .onAppear {
      viewStore.send(.getSubPath)
      viewStore.send(.getRootPath)
    }
  }
}
