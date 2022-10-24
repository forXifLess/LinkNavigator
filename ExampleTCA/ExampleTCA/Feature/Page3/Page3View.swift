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
      Text("Page 3")
        .font(.largeTitle)

      NavigationStackViewer(paths: viewStore.rootPath)
      NavigationStackViewer(paths: viewStore.subPath)

      Button(action: { viewStore.send(.onTapBackOrNext)}) {
        VStack {
          Text("back to Home")
          Text("navigator.backOrNext(path: \"home\", items: [:], isAnimated: true)")
            .font(.caption)
            .foregroundColor(.secondary)
        }
      }

      Button(action: { viewStore.send(.onRemovePage1and2) }) {
        VStack {
          Text("remove Page 1 and 2")
            .foregroundColor(.red)
          Text("navigator.remove(paths: [\"page1\", \"page2\"])")
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

      Button(action: { viewStore.send(.onTapClose) }) {
        VStack {
          Text("close (only available in modal)")
            .foregroundColor(.red)
          Text("navigator.close { print(\"modal dismissed!\") }")
            .font(.caption)
            .foregroundColor(.secondary)
        }
      }

      Button(action: { viewStore.send(.onTapReset) }) {
        VStack {
          Text("reset")
            .foregroundColor(.red)
          Text("navigator.replace(paths: [\"home\"], items: [:], isAnimated: true)")
            .font(.caption)
            .foregroundColor(.secondary)
        }
      }
    }
    .padding(.horizontal)
    .navigationTitle("Page 3")
    .onAppear {
      viewStore.send(.getSubPath)
      viewStore.send(.getRootPath)
    }
  }
}
