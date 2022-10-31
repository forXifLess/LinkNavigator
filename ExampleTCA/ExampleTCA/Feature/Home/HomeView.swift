import ComposableArchitecture
import SwiftUI

public struct HomeView {
  private let store: StoreOf<Home>
  @ObservedObject var viewStore: ViewStoreOf<Home>

  public init(store: StoreOf<Home>) {
    self.store = store
    viewStore = ViewStore(store)
  }
}

extension HomeView: View {
  public var body: some View {
    ScrollView {
      VStack(spacing: 40) {
        Text("Home")
          .font(.system(size: 60, weight: .thin))

        let _ = print(viewStore.state)

        NavigationStackViewer(paths: viewStore.paths)

        Button(action: { viewStore.send(.onTapNext) }) {
          VStack {
            Text("go to next Page")
            Text("navigator.next(paths: [\"page1\"], items: [:], isAnimated: true)")
              .code()
          }
        }

        Button(action: { viewStore.send(.onTapPage3) }) {
          VStack {
            Text("go to Page 3")
            Text("navigator.next(paths: [\"page1\", \"page2\", \"page3\"], items: [:], isAnimated: true)")
              .code()
          }
        }

        Button(action: { viewStore.send(.onTapSheet) }) {
          VStack {
            Text("open Page 2 as Sheet")
              .foregroundColor(.purple)
            Text("navigator.sheet(paths: [\"page1\", \"page2\"], items: [:], isAnimated: true)")
              .code()
          }
        }

        Button(action: { viewStore.send(.onTapFullSheet) }) {
          VStack {
            Text("open Page 2 as Full Screen Sheet")
              .foregroundColor(.purple)
            Text("navigator.fullSheet(paths: [\"page1\", \"page2\"], items: [:], isAnimated: true)")
              .code()
          }
        }

        Spacer()
      }
      .padding(.horizontal)
      .navigationTitle("Home")
      .onAppear {
        viewStore.send(.getPaths)
      }
    }
  }
}
