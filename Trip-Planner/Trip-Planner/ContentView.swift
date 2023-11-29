import SwiftUI

extension Color {
    init(hex: Int, opacity: Double = 1.0) {
        let red = Double((hex >> 16) & 0xff) / 255
        let green = Double((hex >> 8) & 0xff) / 255
        let blue = Double((hex >> 0) & 0xff) / 255
        
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}

struct ContentView: View {
    @State private var showMainView = false
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(Color(hex: 0xF73E6C))]
        appearance.backgroundColor = UIColor(Color(hex: 0xFFFFFF))
        appearance.shadowColor = .clear
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        ZStack {
            if showMainView {
                TabView {
                    ExploreView()
                        .tabItem {
                            Image(systemName: "globe")
                            Text("탐색")
                        }
                    WishListView()
                        .tabItem {
                            Image(systemName: "heart")
                            Text("위시리스트")
                        }
                    Text("")
                        .tabItem {
                            Image(systemName: "calendar")
                            Text("일정")
                        }
                    Text("")
                        .tabItem {
                            Image(systemName: "character.bubble")
                            Text("AI 챗")
                        }
                    Text("")
                        .tabItem {
                            Image(systemName: "gearshape")
                            Text("설정")
                        }
                }
                .accentColor(Color(hex: 0xF73E6C))
            } else {
                SplashView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                            withAnimation {
                                showMainView = true
                            }
                        }
                    }
            }
        }
    }
}

#Preview {
    ContentView()
}
