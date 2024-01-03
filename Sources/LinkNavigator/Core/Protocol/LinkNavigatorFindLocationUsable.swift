import Foundation

/// MARK: - LinkNavigatorFindLocationUsable
///
/// A protocol that defines interfaces for retrieving the current paths in a router page navigation.
public protocol LinkNavigatorFindLocationUsable {

  /// Retrieves the current paths in the router page.
  ///
  /// This method is used to obtain the current paths that are being navigated in the router page.
  /// It returns an array of strings representing the paths.
  ///
  /// - Returns: An array of strings representing the current paths.
  func getCurrentPaths() -> [String]

  /// Retrieves the root current paths in the router page.
  ///
  /// This method is used to obtain the root paths that are being navigated in the router page.
  /// Similar to `getCurrentPaths`, but returns the root paths. It returns an array of strings representing the paths.
  ///
  /// - Returns: An array of strings representing the root current paths.
  func getCurrentRootPaths() -> [String]
}
