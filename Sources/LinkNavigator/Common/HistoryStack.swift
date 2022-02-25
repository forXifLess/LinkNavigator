import UIKit

public struct HistoryStack {

  let stack: [ViewableRouter]

  func mutate(stack: [ViewableRouter]) -> Self {
    .init(stack: stack)
  }

  func reorderStack(viewControllers: [WrapperController]) -> Self {
    let newStack = stack.filter { router in
      viewControllers.first(where: { $0.key ==  router.key }) != nil
    }
    return .init(stack: newStack)
  }
}

extension HistoryStack {
  init() {
    self.init(stack: [])
  }
}
