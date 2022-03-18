import UIKit
import SwiftUI

public final class WrapperController: UIHostingController<AnyView> {
  let key: String
  let reloadCompletion: (() -> Void)?

  public init(rootView: AnyView, key: String, reloadCompletion: (() -> Void)? = .none) {
    self.key = key
    self.reloadCompletion = reloadCompletion
    super.init(rootView: rootView)
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
