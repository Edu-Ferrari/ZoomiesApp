import SwiftUI

struct StatChip: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.caption.bold())
            .padding(.horizontal, 10).padding(.vertical, 6)
            .background(Capsule().fill(.ultraThinMaterial))
    }
}
