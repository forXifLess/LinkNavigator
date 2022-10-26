import ComposableArchitecture
import SwiftUI

public struct Page4View {
  private let store: StoreOf<Page4>
  @ObservedObject var viewStore: ViewStoreOf<Page4>

  public init(store: StoreOf<Page4>) {
    self.store = store
    viewStore = ViewStore(store)
  }
}

extension Page4View: View {
  public var body: some View {
    VStack(spacing: 40) {
      Text("4")
        .font(.system(size: 70, weight: .thin))

      NavigationStackViewer(paths: viewStore.paths)

      Button(action: { viewStore.send(.onTapBackToHome)}) {
        VStack {
          Text("back to Home")
          Text("navigator.backOrNext(path: \"home\", items: [:], isAnimated: true)")
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

      Button(action: { viewStore.send(.onTapReset) }) {
        VStack {
          Text("reset")
            .foregroundColor(.red)
          Text("navigator.replace(paths: [\"home\"], items: [:], isAnimated: true)")
            .font(.caption)
            .foregroundColor(.secondary)
        }
      }

      Spacer()
    }
    .padding(.horizontal)
    .navigationTitle("Page 4")
    .onAppear {
      viewStore.send(.getPaths)
    }
  }
}
