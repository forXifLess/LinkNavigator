import SwiftUI

struct NavigationStackViewer: View {
  let paths: [String]

  var body: some View {
    GroupBox {
      VStack(spacing: 10) {
        HStack {
          Image(systemName: "square.stack.3d.down.right.fill")
          Text("Navigation Stack")
        }
        .font(.footnote)
        .foregroundColor(.secondary)

        Text(paths.map { $0.replacingOccurrences(of: "page", with: "") }.joined(separator: " → "))
      }
    }
    .padding(.horizontal)
  }
}
