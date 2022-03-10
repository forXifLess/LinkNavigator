import SwiftUI

// MARK: - HomeView

struct HomeView: IntentBidingType {
  @StateObject var container: Container<HomeIntentType, HomeModel.State>
  var intent: HomeIntentType { container.intent }
  var state: HomeModel.State { intent.state }
}

// MARK: View

extension HomeView: View {
  var body: some View {
    VStack {
      Text("Home View")
      Button(action: { intent.send(action: .onTapSetting) }) {
        Text("Go to settings")
      }
      Button(action: { intent.send(action: .onTapRouteError)}) {
        Text("Route Error")
      }
      Button(action: { intent.send(action: .onTapNewNotification)}) {
        Text("open sheet type notification")
      }
    }
  }
}

extension HomeView {
  static func build(intent: HomeIntent) -> some View {
    HomeView(
      container: .init(
        intent: intent as HomeIntentType,
        state: intent.state,
        modelChangePublisher: intent.objectWillChange))
  }
}
