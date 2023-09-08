import Foundation

/// `NavigationTarget` enum defines the target where a navigation action should be directed in a `LinkNavigator`.
/// This enum is a part of a navigation handling system where the concept of 'Base' and 'Sub' is used to manage navigation flows more efficiently.
/// 'Base' refers to a UINavigationViewController instance whereas 'Sub' refers to a UIViewController that is presented using UINavigationViewController's present function like alerts, sheets, modals etc.
public enum NavigationTarget: Equatable {

  /// The default case is used when it is not determined whether the current screen is 'Base' or 'Sub', or when it needs to automatically decide the appropriate target to present.
  case `default`

  /// The root case refers to the base UINavigationViewController which serves as the main navigation controller.
  case root

  /// The sub case is used to refer to a UIViewController instance that is presented using the present method of UINavigationViewController like alerts, sheets, modals etc.
  case sub
}
