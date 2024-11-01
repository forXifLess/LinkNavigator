import Foundation

final class SharedRootViewModel: ObservableObject {
  @Published var text: String = "Initialized"

  func update(text: String) {
    self.text = text
  }
}
