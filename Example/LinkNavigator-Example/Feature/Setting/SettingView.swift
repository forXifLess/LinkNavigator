import SwiftUI

// MARK: - SettingView

struct SettingView: IntentBidingType {
  @StateObject var container: Container<SettingIntentType, SettingModel.State>
  var intent: SettingIntentType { container.intent }
  var state: SettingModel.State { intent.state }
}

// MARK: View

extension SettingView: View {
  var body: some View {
    VStack {
      Text("Setting View")
      Button(action: { intent.send(action: .onTapBack) }) {
        Text("Back")
      }
      Button(action: { intent.send(action: .onTapNotification)}) {
        Text("Go to Notificaition")
      }
    }
  }
}

extension SettingView {
  static func build(intent: SettingIntent) -> some View {
    SettingView(
      container: .init(
        intent: intent as SettingIntentType,
        state: intent.state,
        modelChangePublisher: intent.objectWillChange))
  }
}
