import UIKit
import SwiftUI

public final class WrapperController: UIHostingController<AnyView> {
  let key: String

  public init(rootView: AnyView, key: String) {
    self.key = key
    super.init(rootView: rootView)
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
