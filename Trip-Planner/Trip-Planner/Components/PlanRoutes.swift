import SwiftUI

// 경로를 표시하는 뷰를 관리하는 UIViewControllerRepresentable 프로토콜을 채택한 래퍼
struct PlanRoutesWrapper: UIViewControllerRepresentable {
    var sourceLatitude: Double
    var sourceLongitude: Double
    var sourceName: String
    var destinationLatitude: Double
    var destinationLongitude: Double
    var destinationName: String
    
    // UIViewControllerRepresentable 프로토콜의 요구사항으로 실제 UIViewController를 생성하는 메서드
    func makeUIViewController(context: Context) -> PlanRoutesMap {
        let viewController = PlanRoutesMap()
        // 전달된 데이터를 PlanRoutesMap의 프로퍼티에 설정
        viewController.sourceLatitude = sourceLatitude
        viewController.sourceLongitude = sourceLongitude
        viewController.sourceName = sourceName
        viewController.destinationLatitude = destinationLatitude
        viewController.destinationLongitude = destinationLongitude
        viewController.destinationName = destinationName
        return viewController
    }
    
    // 뷰가 업데이트되었을 때의 동작을 정의하는 메서드 (현재는 빈 구현)
    func updateUIViewController(_ uiViewController: PlanRoutesMap, context: Context) {}
}

// 경로 확인 화면을 표시하는 뷰
struct PlanRoutes: View {
    var sourceLatitude: Double
    var sourceLongitude: Double
    var sourceName: String
    var destinationLatitude: Double
    var destinationLongitude: Double
    var destinationName: String
    
    var body: some View {
        VStack {
            // PlanRoutesWrapper를 사용하여 경로를 표시하는 UIViewController를 래핑
            PlanRoutesWrapper(
                sourceLatitude: sourceLatitude,
                sourceLongitude: sourceLongitude,
                sourceName: sourceName,
                destinationLatitude: destinationLatitude,
                destinationLongitude: destinationLongitude,
                destinationName: destinationName
            )
        }
        .navigationBarTitle("경로 확인", displayMode: .inline)
    }
}
