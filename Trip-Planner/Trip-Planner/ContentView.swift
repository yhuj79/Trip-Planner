import SwiftUI

struct ContentView: View {
    var body: some View {
        Image("logo").resizable().scaledToFit().frame(width: 500)
        Text("Loading...")
    }
}

#Preview {
    ContentView()
}
