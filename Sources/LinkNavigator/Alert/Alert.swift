import UIKit

public struct Alert {
  public enum FlagType {
    case error
    case `default`
  }

  let title: String?
  let message: String
  let buttons: [ActionButton]
  let flagType: FlagType

  public init(title: String? = .none, message: String?, buttons: [ActionButton], flagType: FlagType) {
    self.title = title ?? ""
    self.message = message ?? ""
    self.buttons = buttons
    self.flagType = flagType
  }

  func build() -> UIAlertController {
    let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
    buttons.forEach {
      controller.addAction($0.buildAlertButton())
    }
    return controller
  }

}
