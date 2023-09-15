//import Foundation
//
//// MARK: - EmptyValueType
//
///// A protocol that defines an `empty` property for types that conform to it.
///// This property represents the 'empty' state for that particular type, providing a standardized way to define what constitutes an 'empty' state for different types.
//public protocol EmptyValueType {
//
//    /// A property representing the 'empty' state of the conforming type.
//    static var empty: Self { get }
//}
//
//// MARK: - String + EmptyValueType
//
///// An extension that conforms `String` type to the `EmptyValueType` protocol.
///// By conforming to this protocol, a `String` type can represent its 'empty' state through the `empty` property, which in this case, is an empty string ("").
//extension String: EmptyValueType {
//
//    /// The representation of an 'empty' state for a `String` type, defined as an empty string ("").
//    public static var empty: Self { "" }
//}
//
//// MARK: - Dictionary<String, String> + EmptyValueType
//
///// An extension that conforms `Dictionary` with `String` keys and `String` values to the `EmptyValueType` protocol.
///// By conforming to this protocol, a dictionary with `String` keys and `String` values can represent its 'empty' state through the `empty` property, which in this case, is an empty dictionary (`[:]`).
//extension [String: String]: EmptyValueType {
//
//    /// The representation of an 'empty' state for a dictionary with `String` keys and `String` values, defined as an empty dictionary (`[:]`).
//    public static var empty: [String: String] { [:] }
//}
