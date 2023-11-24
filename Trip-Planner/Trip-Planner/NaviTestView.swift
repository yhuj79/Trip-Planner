import SwiftUI

struct NaviTestView: View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: MapView()) {
                    Text("Go to Detail View")
                }
            }
        }
    }
}

#Preview {
    NaviTestView()
}
