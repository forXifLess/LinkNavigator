import Foundation

// MARK: - DependencyType

/// The `DependencyType` protocol is utilized to resolve dependencies in a DI container.
///
/// This protocol is designed to return an instance of a specific type through the `resolve` method. It's utilized in conjunction with `RouteBuilder` to inject external functionalities, akin to the SideEffect in MVI or UseCase in Clean Architecture, into individual pages.
///
/// Developers using the library can facilitate dependency injection by adding this protocol for external dependencies and injecting it into the `LinkNavigator` initialization function. This allows the injected container to be utilized during page creation through `RouteBuilder`.
///
/// The `resolve` function is passed to `RouteBuilder` with a declared protocol of `DependencyType`. During the build, it allows for the transformation into the necessary DI type for use in each page.
public protocol DependencyType {
  /// This function attempts to resolve a dependency of the specified type `T`.
  ///
  /// It tries to cast `self` to the specified type and returns it if successful. If the cast fails, it returns `nil`. This is used to fetch necessary dependencies at runtime, facilitating dependency injection and inversion of control.
  func resolve<T>() -> T?
}

extension DependencyType {
  /// Default implementation of the `resolve` function.
  ///
  /// It tries to cast `self` to the specified type and returns it if successful. If the cast fails, it returns `nil`.
  public func resolve<T>() -> T? {
    self as? T
  }
}
