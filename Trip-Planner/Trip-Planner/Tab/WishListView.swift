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
                // 네비게이션 바 왼쪽 아이템
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {}) {
                        Label("Send", systemImage: "person.crop.circle")
                    }
                }
                // 네비게이션 바 오른쪽 아이템
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
