#if canImport(UIKit)

import UIKit
import SwiftUI

public final class WrapperController: UIHostingController<AnyView> {
  let key: String
  let reloadCompletion: (() -> Void)?
  let callbackCompletion: (([String: QueryItem]) -> Void)?

  public init(rootView: AnyView, key: String, reloadCompletion: (() -> Void)? = .none, callbackCompletion: (([String: QueryItem]) -> Void)? = .none) {
    self.key = key
    self.reloadCompletion = reloadCompletion
    self.callbackCompletion = callbackCompletion
    super.init(rootView: rootView)
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

#endif
