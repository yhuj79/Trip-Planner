import SwiftUI

// 앱 시작 시 나타나는 스플래시 화면을 정의하는 뷰
struct SplashView: View {
    var body: some View {
        VStack {
            // 로고 이미지를 표시하고 크기 및 비율 조정
            Image("logo").resizable().scaledToFit().frame(width: 400)
            // SpinnerCircle 뷰를 삽입하고 여백 추가
            SpinnerCircle().padding(30)
        }
    }
}

// 회전하는 동그라미 형태의 스피너를 표시하는 뷰
struct SpinnerCircle: View {
    @State private var isAnimating = false
    
    var body: some View {
        // 원 모양의 스피너를 그리기 위한 Circle 뷰 설정
        Circle()
            .trim(from: 0, to: 0.7)  // 일부만 그리도록 설정
            .stroke(Color(red: 1.0, green: 0.306, blue: 0.302), lineWidth: 6)  // 테두리 색상 및 두께 설정
            .frame(width: 50, height: 50)  // 크기 설정
            .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))  // 회전 애니메이션 설정
            .animation(Animation.linear(duration: 0.7).repeatForever(autoreverses: false), value: UUID())  // 애니메이션 적용 및 반복 설정
            .onAppear {
                self.isAnimating = true  // 뷰가 나타나면 애니메이션 시작
            }
    }
}

#Preview {
    SplashView()
}
