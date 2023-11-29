import SwiftUI

struct ExploreView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                Package()
                TSpot()
                Accommodation()
            }
            .navigationBarTitle("탐색")
        }
    }
}

#Preview {
    ExploreView()
}
