import SwiftUI

struct ContentView: View {
    @State private var showMainView = false
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = UIColor(Color(red: 247, green: 247, blue: 247))
        UITabBar.appearance().standardAppearance = appearance
    }
    
    var body: some View {
        ZStack {
            if showMainView {
                TabView {
                    MapView()
                        .tabItem {
                            Image(systemName: "globe")
                            Text("탐색")
                        }
                    TestView()
                        .tabItem {
                            Image(systemName: "heart")
                            Text("위시리스트")
                        }
                    NaviTestView()
                        .tabItem {
                            Image(systemName: "calendar")
                            Text("일정")
                        }
                    NaviTestView()
                        .tabItem {
                            Image(systemName: "character.bubble")
                            Text("AI 챗")
                        }
                    NaviTestView()
                        .tabItem {
                            Image(systemName: "gearshape")
                            Text("설정")
                        }
                }
                .accentColor(Color(red: 0.933, green: 0.49, blue: 0.49))
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
