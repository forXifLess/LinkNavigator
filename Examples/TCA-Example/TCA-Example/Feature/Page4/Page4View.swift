import ComposableArchitecture
import SwiftUI

// MARK: - Page4View

public struct Page4View {
  private let store: StoreOf<Page4>
  @ObservedObject var viewStore: ViewStoreOf<Page4>

  public init(store: StoreOf<Page4>) {
    self.store = store
    viewStore = ViewStore(store, observe: { $0 })
  }
}

// MARK: View

extension Page4View: View {
  public var body: some View {
    ScrollView {
      VStack(spacing: 40) {
        Text("4")
          .font(.system(size: 70, weight: .thin))

        VStack {
          NavigationStackViewer(paths: viewStore.paths)

          GroupBox {
            VStack(spacing: 10) {
              HStack {
                Image(systemName: "envelope")
                Text("Received Message")
              }
              .font(.footnote)
              .foregroundColor(.secondary)

              Text(viewStore.message.isEmpty ? "-" : viewStore.message)
            }
          }
        }

        Button(action: { viewStore.send(.onTapDeepLink) }) {
          VStack {
            Text("copy deep link")
              .foregroundColor(.green)
            Text("URL → tca-ex://host/home/page1/page2/page3/page4?page3-message=world&page4-message=hello")
              .code()
          }
        }

        Button(action: { viewStore.send(.onTapBackToHome) }) {
          VStack {
            Text("back to Home")
            Text("navigator.backOrNext(path: \"home\", items: [:], isAnimated: true)")
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

        Button(action: { viewStore.send(.onTapReset) }) {
          VStack {
            Text("reset")
              .foregroundColor(.red)
            Text("navigator.replace(paths: [\"home\"], items: [:], isAnimated: true)")
              .code()
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
}
