import SwiftUI

// MARK: - PlaceView

struct PlaceView: IntentBidingType {
  @StateObject var container: Container<PlaceIntentType, PlaceModel.State>
  var intent: PlaceIntentType { container.intent }
  var state: PlaceModel.State { intent.state }
}

// MARK: View

extension PlaceView: View {
  var body: some View {
    VStack {
      Text("Place View")
      Text("Place ID = \(state.placeID)")
      Button(action: { intent.send(action: .onTapBack) }) {
        Text("Back")
      }
    }
  }
}

extension PlaceView {
  static func build(intent: PlaceIntent) -> some View {
    PlaceView(
      container: .init(
        intent: intent as PlaceIntentType,
        state: intent.state,
        modelChangePublisher: intent.objectWillChange))
  }
}
