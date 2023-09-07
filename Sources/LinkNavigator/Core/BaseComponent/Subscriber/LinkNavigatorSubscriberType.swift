import Foundation

/// A protocol that outlines methods for receiving a dictionary item. The dictionary contains key-value pairs where both the key and value are strings.
public protocol LinkNavigatorDictionaryItemSubscriberProtocol {
  
  /// Receives a dictionary item and performs an action with it.
  /// 
  /// The dictionary parameter contains key-value pairs where both key and value are strings.
  /// 
  /// - Parameter item: A dictionary containing string keys and values.
  func receive(item: [String: String])
}

/// A protocol that outlines methods for receiving a URL encoded string item.
public protocol LinkNavigatorURLEncodedItemSubscriberProtocol {
  
  /// Receives a URL encoded string item and performs an action with it.
  /// 
  /// - Parameter item: A URL encoded string.
  func receive(item: String)
}

/// An enumeration that defines the types of subscribers that a link navigator can have.
public enum LinkNavigatorSubscriberType {
  
  /// A case representing a subscriber that adheres to the `LinkNavigatorDictionaryItemSubscriberProtocol` protocol.
  case dictionary(LinkNavigatorDictionaryItemSubscriberProtocol)
  
  /// A case representing a subscriber that adheres to the `LinkNavigatorURLEncodedItemSubscriberProtocol` protocol.
  case urlEncoded(LinkNavigatorURLEncodedItemSubscriberProtocol)
}
