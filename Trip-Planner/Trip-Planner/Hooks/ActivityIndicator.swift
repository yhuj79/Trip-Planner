import SwiftUI

// 이미지가 로드 중임을 나타내는 뷰
struct ActivityIndicator: View {
    var body: some View {
        ProgressView()
        // CircularProgressViewStyle로 스타일 지정, tint 색상 설정
            .progressViewStyle(CircularProgressViewStyle(tint: Color(hex: 0xF73E6C)))
        // 크기 조절 및 앵커 지정
            .scaleEffect(1.5, anchor: .center)
    }
}
