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
    ExploreView()
}
