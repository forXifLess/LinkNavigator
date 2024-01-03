import Foundation

/// A protocol that outlines methods for receiving a dictionary item. The dictionary contains key-value pairs where both the key and value are strings.
public protocol LinkNavigatorItemSubscriberProtocol {

  /// Receives a dictionary item and performs an action with it.
  ///
  /// The dictionary parameter contains key-value pairs where both key and value are strings.
  ///
  /// - Parameter item: A dictionary containing string keys and values.
  func receive(encodedItemString: String)
}
