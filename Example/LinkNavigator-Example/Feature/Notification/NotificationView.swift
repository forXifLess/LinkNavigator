import SwiftUI

// MARK: - NotificationView

struct NotificationView: IntentBidingType {
  @StateObject var container: Container<NotificationIntentType, NotificationModel.State>
  var intent: NotificationIntentType { container.intent }
  var state: NotificationModel.State { intent.state }
}

// MARK: View

extension NotificationView: View {
  var body: some View {
    VStack {
      Text("Notification View")
      Button(action: { intent.send(action: .onTapBack) }) {
        Text("Back")
      }
      Button(action: { intent.send(action: .onTapPlaceList) }) {
        Text("Go to Place List")
      }
    }
  }
}

extension NotificationView {
  static func build(intent: NotificationIntent) -> some View {
    NotificationView(
      container: .init(
        intent: intent as NotificationIntentType,
        state: intent.state,
        modelChangePublisher: intent.objectWillChange))
  }
}
