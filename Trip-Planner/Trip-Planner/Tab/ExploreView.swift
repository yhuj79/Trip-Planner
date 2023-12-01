import SwiftUI

struct ExploreView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                Spacer()
                Package()
                TSpot()
                Accommodation()
            }
            .navigationBarTitle("탐색")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {}) {
                        Label("Send", systemImage: "person.crop.circle")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {}) {
                        Label("Refresh", systemImage: "gearshape")
                    }
                }
            }
        }
    }
}

#Preview {
    ExploreView()
}
