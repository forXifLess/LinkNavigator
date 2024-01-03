import UIKit

/// A struct representing a customizable action button.
///
/// This struct allows you to create a button with a specified title, style, and action closure.
public struct ActionButton: Equatable {

  // MARK: Lifecycle

  /// Initializes a new action button with the provided parameters.
  ///
  /// - Parameters:
  ///   - title: The title of the button. Defaults to nil.
  ///   - style: The style of the button, which determines its appearance and behavior.
  ///   - action: The closure to execute when the button is pressed. Defaults to an empty closure.
  public init(title: String? = .none, style: ActionStyle, action: @escaping () -> Void = { }) {
    self.title = title ?? "title"
    self.style = style
    self.action = action
  }

  // MARK: Public

  /// Enumeration representing the different styles a button can have.
  ///
  /// These styles influence the button's appearance and behavior in the UI.
  public enum ActionStyle {
    case `default` /// < Represents the default style for a button.
    case cancel /// < Represents a cancel style, generally used for cancel buttons.
    case destructive /// < Represents a destructive style, generally used for actions that have destructive behaviors.

    /// Computed property that maps ActionStyle cases to their corresponding UIAlertAction.Style counterparts.
    var uiRawValue: UIAlertAction.Style {
      switch self {
      case .default: return .default
      case .cancel: return .cancel
      case .destructive: return .destructive
      }
    }
  }

  /// Equatable protocol method to compare two ActionButton instances.
  ///
  /// - Parameters:
  ///   - lhs: An ActionButton instance.
  ///   - rhs: Another ActionButton instance.
  ///
  /// - Returns: A boolean indicating whether the two instances are equal.
  public static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.title == rhs.title
  }

  // MARK: Internal

  /// The title of the action button.
  let title: String
  /// The style of the action button.
  let style: ActionStyle
  /// The closure to be executed when the button is pressed.
  let action: () -> Void

  /// Creates a UIAlertAction instance with the properties of this ActionButton.
  ///
  /// - Returns: A UIAlertAction instance with the button's title, style, and action closure.
  func buildAlertButton() -> UIAlertAction {
    .init(title: title, style: style.uiRawValue) { _ in action() }
  }
}
