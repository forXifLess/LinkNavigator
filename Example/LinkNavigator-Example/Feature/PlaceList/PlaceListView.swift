import SwiftUI

// MARK: - PlaceListView

struct PlaceListView: IntentBidingType {
  @StateObject var container: Container<PlaceListIntentType, PlaceListModel.State>
  var intent: PlaceListIntentType { container.intent }
  var state: PlaceListModel.State { intent.state }
}

// MARK: View

extension PlaceListView: View {
  var body: some View {
    VStack {
      Text("PlaceList View")
      Button(action: { intent.send(action: .onTapBack) }) {
        Text("Back")
      }

      ScrollView {
        LazyVStack {
          ForEach(state.places, id: \.self) { id in
            Button(action: { intent.send(action: .onTapPlace(id)) }) {
              Text("Go to Place-\(id)")
            }
          }
        }
      }
    }
    .onAppear {
      intent.send(action: .getPlaceList)
    }
  }
}

extension PlaceListView {
  static func build(intent: PlaceListIntent) -> some View {
    PlaceListView(
      container: .init(
        intent: intent as PlaceListIntentType,
        state: intent.state,
        modelChangePublisher: intent.objectWillChange))
  }
}
