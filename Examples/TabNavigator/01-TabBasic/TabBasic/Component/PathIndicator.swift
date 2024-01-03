import SwiftUI

public struct PathIndicator: View {
  let currentPath: String

  public var body: some View {
    VStack(spacing: 16) {
      Text("currentPath")
        .font(.headline)

      Text(currentPath)
        .font(.subheadline)
    }
    .padding()
    .frame(maxWidth: .infinity)
    .background(
      RoundedRectangle(cornerRadius: 12).fill(.green.opacity(0.3)))
    .padding(.horizontal)
  }
}
