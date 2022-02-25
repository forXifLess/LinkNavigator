import Combine
import Foundation

// MARK: - IntentType

protocol IntentType: AnyObject {
  associatedtype ViewAction
  associatedtype State

  var state: State { get set }
  var cancellable: Set<AnyCancellable> { get set }

  func send(action: ViewAction)
  func send(action: ViewAction, viewEffect: (() -> Void)?)
  func mutate(action: ViewAction, viewEffect: (() -> Void)?)
}

extension IntentType {

  func send(action: ViewAction) {
    mutate(action: action, viewEffect: .none)
  }

  func send(action: ViewAction, viewEffect: (() -> Void)?) {
    mutate(action: action, viewEffect: viewEffect)
  }
}

// MARK: - IntentBidingType

protocol IntentBidingType {
  associatedtype IntentType
  associatedtype State

  var container: Container<IntentType, State> { get }
  var intent: IntentType { get }
  var state: State { get }
}
