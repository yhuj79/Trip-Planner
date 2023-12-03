import SwiftUI
import MapKit

// 관광지 상세 정보를 표시하는 TSpotDetail View
struct TSpotDetail: View {
    // 관광지 정보를 담는 속성
    var spot: TSpotResult
    // 위시리스트 변경 여부를 확인하는 Alert 표시 상태
    @State private var showAlert = false
    
    var body: some View {
        // 수직 ScrollView를 사용하여 UI 구성
        ScrollView {
            // 수직 LazyVStack을 사용하여 관광지 정보 표시
            LazyVStack(alignment: .leading, spacing: 0) {
                // 관광지 이미지 표시
                AsyncImage(url: spot.image_url)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width, height: 250)
                    .clipped()
                    .overlay (
                        Rectangle()
                            .fill(Color.black.opacity(0.05))
                    )
                // 관광지 이름 및 국제 이름 표시
                VStack(alignment: .leading) {
                    Text(spot.name)
                        .bold()
                        .font(.system(size: 27))
                        .padding(.bottom, 1)
                    Text(spot.intl_name)
                        .bold()
                        .font(.system(size: 18))
                        .foregroundColor(Color(hex: 0x5D5D5D))
                }
                .padding(.horizontal, 13)
                .padding(.top, 13)
                .padding(.bottom, 3)
                // 관광지 설명 표시
                Text(spot.description)
                    .font(.system(size: 16))
                    .padding(15)
                // 국가, 도시 정보 및 Wikipedia 링크 표시
                HStack {
                    HStack {
                        Image("\(spot.country)")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30)
                            .padding(10)
                        
                        Text("\(spot.country) \(spot.city_name)")
                            .font(.system(size: 18))
                            .bold()
                            .padding(10)
                    }
                    .background(Color.black.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    Spacer()
                    HStack {
                        // Wikipedia 링크로 이동하는 Link 표시
                        Link(destination: URL(string: "https://ko.wikipedia.org/wiki/\(spot.name)")!) {
                            Image(systemName: "doc.text.magnifyingglass")
                                .font(.system(size: 16))
                            Text("Wikipedia")
                                .font(.system(size: 16))
                        }
                        .foregroundColor(Color(hex: 0x4374D9))
                    }
                }
                .padding(12)
                // 지도 화면으로 이동하는 NavigationLink 표시
                NavigationLink(destination: MapView(title: spot.name, latitude: spot.latitude, longitude: spot.longitude)) {
                    HStack {
                        Image(systemName: "map.circle")
                        Text("지도 전체화면으로 보기")
                    }
                }
                .foregroundColor(Color(hex: 0xF73E6C))
                .padding(10)
                // 지도 표시
                Map(initialPosition: .region(region))
                    .frame(height: 250)
            }
            .toolbar {
                // 우측 상단 메뉴 버튼 설정
                ToolbarItem {
                    Menu {
                        Section("\(spot.name) (\(spot.intl_name))") {
                            // 위시리스트 추가/제거 버튼 설정
                            Button {
                                updateWishTSpot()
                            } label: {
                                Label("위시리스트 \(spot.wish != 0 ? "삭제" : "등록")", systemImage: "\(spot.wish != 0 ? "heart.fill" : "heart")")
                            }
                        }
                    } label: {
                        Label("Menu", systemImage: "ellipsis.circle")
                    }
                }
            }
            // 위시리스트 변경 여부에 따라 표시되는 Alert 설정
            .alert(isPresented: $showAlert) {
                Alert(title: Text("위시리스트"), message: Text("\(spot.wish != 0 ? "삭제가 완료되었습니다." : "등록이 완료되었습니다.")"))
            }
            // 네비게이션 바 타이틀 설정
            .navigationBarTitle("관광지 정보", displayMode: .inline)
        }
    }
    
    // 지도의 초기 위치 및 확대/축소 설정
    private var region: MKCoordinateRegion {
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: spot.latitude, longitude: spot.longitude),
            span: MKCoordinateSpan(latitudeDelta: 0.007, longitudeDelta: 0.007)
        )
    }
    
    // 위시리스트 업데이트 함수
    func updateWishTSpot() {
        Task {
            do {
                // 위시리스트 업데이트를 위한 API 호출
                guard let url = URL(string: "http://localhost:5500/api/tourist_spot/wish/update/\(spot.wish == 1 ? 0 : 1)/\(spot.id)") else {
                    print("Invalid URL")
                    return
                }
                
                let (_, meta) = try await URLSession.shared.data(from: url)
                print(meta)
                // Alert 표시
                showAlert.toggle()
                
            } catch {
                print("Invalid data")
            }
        }
    }
}
