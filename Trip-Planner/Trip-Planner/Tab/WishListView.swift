import SwiftUI

struct WishListView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                WishPackage()
                WishTSpot()
                WishAccommodation()
            }
            .navigationBarTitle("위시리스트")
        }
    }
}

#Preview {
    WishListView()
}
