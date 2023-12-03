import SwiftUI

// Color 확장(extension)으로 hex 코드를 사용하여 Color를 생성하는 기능 추가
extension Color {
    init(hex: Int, opacity: Double = 1.0) {
        // hex 코드를 RGB로 변환
        let red = Double((hex >> 16) & 0xff) / 255
        let green = Double((hex >> 8) & 0xff) / 255
        let blue = Double((hex >> 0) & 0xff) / 255
        
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}

struct ContentView: View {
    // SplashView를 위한 상태 변수
    @State private var showMainView = false
    
    // ContentView 초기화 메서드
    init() {
        // 네비게이션 바 설정
        let appearance = UINavigationBarAppearance()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(Color(hex: 0xF73E6C))]
        appearance.backgroundColor = UIColor(Color(hex: 0xFFFFFF))

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        ZStack {
            if showMainView {
                // 탭 뷰로 여러 하위 뷰 관리
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
                    PlanView()
                        .tabItem {
                            Image(systemName: "calendar")
                            Text("일정")
                        }
                    ChatView()
                        .tabItem {
                            Image(systemName: "character.bubble")
                            Text("AI 챗")
                        }
                }
                // 강조 색상 설정
                .accentColor(Color(hex: 0xF73E6C))
            } else {
                // 메인 뷰가 표시되기 전에 SplashView를 표시
                SplashView()
                    .onAppear {
                        // 일정 시간이 지난 후에 메인 뷰 표시 및 애니메이션
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
