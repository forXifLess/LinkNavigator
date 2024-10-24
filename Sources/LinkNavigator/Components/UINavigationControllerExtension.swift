import UIKit

/// - Note: iOS17 Bug
/// - seealso: https://github.com/forXifLess/LinkNavigator/issues/46
///
///
extension UINavigationController: ObservableObject, UIGestureRecognizerDelegate {

  // MARK: Open

  override open func viewDidLoad() {
    super.viewDidLoad()
    interactivePopGestureRecognizer?.delegate = self
    navigationBar.isHidden = true
  }

  // MARK: Public

  public func gestureRecognizerShouldBegin(_: UIGestureRecognizer) -> Bool {
    viewControllers.count > 1
  }
}
