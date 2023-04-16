import Combine
import Foundation

final class Container<Intent, State>: ObservableObject {

  // MARK: Lifecycle

  init(
    intent: Intent,
    state: State,
    modelChangePublisher: ObjectWillChangePublisher)
  {
    self.intent = intent
    self.state = state

    modelChangePublisher
      .receive(on: RunLoop.main)
      .sink(receiveValue: objectWillChange.send)
      .store(in: &cancellable)
  }

  // MARK: Internal

  let intent: Intent
  let state: State

  // MARK: Private

  private var cancellable: Set<AnyCancellable> = []

}
