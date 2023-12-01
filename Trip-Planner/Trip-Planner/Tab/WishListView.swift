import SwiftUI

struct WishListView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                Spacer()
                WishPackage()
                WishTSpot()
                WishAccommodation()
            }
            .navigationBarTitle("위시리스트")
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
    WishListView()
}
