import SwiftUI
import MapKit

// 특정 위치의 지도를 표시하는 뷰
struct MapView: View {
    var title: String  // 지도 상단에 표시할 제목
    var latitude: Double  // 중심 좌표의 위도
    var longitude: Double  // 중심 좌표의 경도
    
    var body: some View {
        NavigationView {
            // Map 뷰를 통해 초기 위치 설정 및 표시
            Map(initialPosition: .region(region))
        }
        .navigationBarTitle("\(title)")  // 네비게이션 바에 제목 표시
    }
    
    // 해당 지도의 중심 좌표 및 확대/축소 정도를 설정하는 계산된 속성
    private var region: MKCoordinateRegion {
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),  // 중심 좌표 설정
            span: MKCoordinateSpan(latitudeDelta: 0.007, longitudeDelta: 0.007)  // 확대/축소 정도 설정
        )
    }
}
