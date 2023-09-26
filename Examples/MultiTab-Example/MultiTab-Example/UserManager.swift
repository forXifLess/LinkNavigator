import Foundation

final class UserManager: ObservableObject {
  @Published private(set) var isLogin = false
}

extension UserManager {
  func onChange(isLogin: Bool) {
    self.isLogin = isLogin
  }
}
