import SwiftUI
import WebKit

struct ChatView: View {
    // 키보드 가시성 여부를 나타내는 상태 변수
    @State private var isKeyboardVisible = false
    
    var body: some View {
        NavigationView {
            // WebView를 사용하여 특정 URL을 표시
            WebView(urlString: "https://bard.google.com/chat")
                .edgesIgnoringSafeArea(.all)
                .navigationBarTitle("")
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
        // 화면이 나타날 때 키보드 이벤트를 감지하여 isKeyboardVisible 상태 업데이트
        .onAppear {
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { (notification) in
                isKeyboardVisible = true
            }
            
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { (notification) in
                isKeyboardVisible = false
            }
        }
    }
}

// UIKit의 WKWebView를 SwiftUI에서 사용 가능하도록 하는 WebView 구조체 정의
struct WebView: UIViewRepresentable {
    let urlString: String
    
    // UIView를 생성하는 메서드
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    // UIView를 업데이트하는 메서드
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }
    
    // Coordinator를 생성하는 메서드
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        
        init(_ parent: WebView) {
            self.parent = parent
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
