import UIKit

final class RootNavigationController: UINavigationController {
  override func viewDidLoad() {
    super.viewDidLoad()
    delegate = self
  }
}

extension RootNavigationController: UINavigationControllerDelegate {
  func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {

  }
}
