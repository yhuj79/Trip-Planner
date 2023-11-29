import SwiftUI

struct ActivityIndicator: View {
    var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: Color(hex: 0xF73E6C)))
            .scaleEffect(1.5, anchor: .center)
    }
}
