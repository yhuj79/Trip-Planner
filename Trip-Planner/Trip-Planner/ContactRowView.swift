import SwiftUI

struct ContactRowView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Name").font(.system(size:26, design: .rounded).bold())
            Text("Email").font(.callout.bold())
            Text("Phone Number").font(.callout.bold())
        }.frame(maxWidth: .infinity, alignment: .leading)
            .overlay(alignment: .topTrailing) {
                Button {
                    // adsf
                } label: {
                    Image(systemName: "star")
                        .font(.title3)
                        .symbolVariant(.fill)
                        .foregroundColor(.gray.opacity(0.3))
                }
                .buttonStyle(.plain)
            }
    }
}

#Preview {
    ContactRowView()
}
