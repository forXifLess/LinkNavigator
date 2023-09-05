import Foundation

// MARK: - LinkNavigatorDictionaryItemSubscriberProtocol

public protocol LinkNavigatorDictionaryItemSubscriberProtocol {
  func receive(item: [String: String])
}

// MARK: - LinkNavigatorURLEncodedItemSubscriberProtocol

public protocol LinkNavigatorURLEncodedItemSubscriberProtocol {
  func receive(item: String)
}

// MARK: - LinkNavigatorSubscriberType

public enum LinkNavigatorSubscriberType {
  case dictionary(LinkNavigatorDictionaryItemSubscriberProtocol)
  case urlEncoded(LinkNavigatorURLEncodedItemSubscriberProtocol)
}
