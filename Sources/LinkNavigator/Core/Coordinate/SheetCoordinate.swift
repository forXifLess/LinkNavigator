import UIKit

class SheetCoordinate: NSObject, UIAdaptivePresentationControllerDelegate {

  // MARK: Lifecycle

  init(sheetDidDismiss: @escaping (UIPresentationController) -> Void) {
    self.sheetDidDismiss = sheetDidDismiss
  }

  // MARK: Internal

  var sheetDidDismiss: (UIPresentationController) -> Void

  func presentationControllerDidDismiss(_ present: UIPresentationController) {
    sheetDidDismiss(present)
  }
}
