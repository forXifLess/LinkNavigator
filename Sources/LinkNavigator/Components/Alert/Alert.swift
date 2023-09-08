import UIKit

/// A struct representing a customizable alert.
///
/// This struct allows you to create an alert with a specified title, message, an array of buttons, and a flag type.
public struct Alert: Equatable {

  // MARK: - Lifecycle

  /// Initializes a new alert with the provided parameters.
  ///
  /// - Parameters:
  ///   - title: The title of the alert. Defaults to nil, which will be transformed to an empty string internally.
  ///   - message: The message that the alert displays.
  ///   - buttons: An array of `ActionButton` objects that represent the buttons in the alert.
  ///   - flagType: The type of the flag that categorizes the alert.
  public init(title: String? = .none, message: String?, buttons: [ActionButton], flagType: FlagType) {
    self.title = title ?? ""
    self.message = message ?? ""
    self.buttons = buttons
    self.flagType = flagType
  }

  // MARK: - Public

  /// Enumeration representing the different flag types an alert can have.
  ///
  /// Flag types help to categorize the alerts into various categories such as error or default.
  public enum FlagType: Equatable {
    case error       ///< Represents an error flag type, used to indicate that the alert is presenting an error.
    case `default`   ///< Represents a default flag type, used when no specific categorization is needed.
  }

  // MARK: - Internal

  /// The title of the alert.
  let title: String?
  /// The message that the alert displays.
  let message: String
  /// An array of `ActionButton` objects representing the buttons in the alert.
  let buttons: [ActionButton]
  /// The flag type categorizing the alert.
  let flagType: FlagType

  /// Builds the `UIAlertController` using the properties of this `Alert` instance.
  ///
  /// This function constructs a `UIAlertController` with the title, message, and buttons defined in this `Alert` instance.
  ///
  /// - Returns: A `UIAlertController` instance configured with the properties of this `Alert`.
  func build() -> UIAlertController {
    let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
    for button in buttons {
      controller.addAction(button.buildAlertButton())
    }
    return controller
  }
}
