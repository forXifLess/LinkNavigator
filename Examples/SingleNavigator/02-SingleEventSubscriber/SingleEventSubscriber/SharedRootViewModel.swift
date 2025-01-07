import Foundation

final class SharedRootViewModel: ObservableObject {
  @Published var text = "Initialized"

  func update(text: String) {
    self.text = text
  }
}
