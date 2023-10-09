import Foundation
import LinkNavigator

final class DashboardViewModel: ObservableObject {
  @Published var auth: AuthenticationModel

  init(auth: AuthenticationModel) {
    self.auth = auth
  }
}

extension DashboardViewModel: LinkNavigatorItemSubscriberProtocol {
  func receive(encodedItemString: String) {
    guard let item: AuthenticationModel = encodedItemString.decoded() else { return }
    self.auth = item
  }
}
