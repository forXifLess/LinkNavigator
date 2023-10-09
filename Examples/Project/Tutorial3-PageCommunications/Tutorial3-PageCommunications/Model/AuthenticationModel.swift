import Foundation

struct AuthenticationModel: Codable {
  let isLogin: Bool

  init(isLogin: Bool = false) {
    self.isLogin = isLogin
  }
}
