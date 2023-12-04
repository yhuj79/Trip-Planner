import SwiftUI
import MapKit

// 서버로부터 받아오는 위치 정보를 저장하는 모델
struct LocationResponse: Codable {
    var results: [LocationResult]
}

// 서버로부터 받아오는 위치 결과 항목을 나타내는 모델
struct LocationResult: Codable, Identifiable {
    let id: Int
    let name: String
    let latitude: Double
    let longitude: Double
}

// 지도에 표시할 주석 항목을 나타내는 모델
struct AnnotationItem: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let name: String
}

// 기본 주석 항목을 반환하기 위한 확장
extension AnnotationItem {
    static var example = AnnotationItem(coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0), name: "")
}

// 일정 세부 정보를 표시하는 뷰
struct PlanDetail: View {
    var plan: PlanListResult
    var spotArray: [Int]
    @State private var locationResponse: LocationResponse? = nil
    
    // 지도 리전 상태 변수
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 0.07, longitudeDelta: 0.07)
    )
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                // 지도를 표시하는 부분
                Map(coordinateRegion: $region, annotationItems: [AnnotationItem.example] + additionalAnnotations()) { item in
                    MapAnnotation(coordinate: item.coordinate) {
                        VStack {
                            Image(systemName: "mappin.circle.fill")
                                .foregroundColor(Color.red)
                                .background(
                                    Circle().fill(Color.white)
                                )
                                .frame(width: 22, height: 22)
                            Text(item.name)
                                .lineLimit(nil)
                                .fixedSize(horizontal: true, vertical: true)
                                .multilineTextAlignment(.center)
                                .font(.caption)
                                .foregroundColor(.primary)
                                .padding(.horizontal, 5)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                                .shadow(radius: 5)
                        }
                    }
                }
            }
            .frame(height: 330)
            // 설명 및 경로 표시 부분
            VStack(alignment: .leading) {
                Text("화살표를 클릭하면 경로를 확인할 수 있습니다.")
            }
            .font(.subheadline)
            .foregroundColor(Color(hex: 0x5D5D5D))
            .padding(7)
            Divider()
            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                }
                if let firstSpotID = spotArray.first {
                    // 출발 지점(숙소) 표시
                    Text("\(locationResponse?.results.first(where: { $0.id == plan.accommodation })?.name ?? "")")
                        .font(.system(size: 22))
                        .foregroundColor(Color(hex: 0xF73E6C))
                        .bold()
                        .padding(.horizontal, 10)
                    // 출발 지점에서 첫 번째 관광지로의 경로 표시
                    NavigationLink(
                        destination: PlanRoutes(
                            sourceLatitude: locationResponse?.results.first(where: { $0.id == plan.accommodation })?.latitude ?? 0,
                            sourceLongitude: locationResponse?.results.first(where: { $0.id == plan.accommodation })?.longitude ?? 0,
                            sourceName: locationResponse?.results.first(where: { $0.id == plan.accommodation })?.name ?? "출발 지점",
                            destinationLatitude: locationResponse?.results.first(where: { $0.id == firstSpotID })?.latitude ?? 0,
                            destinationLongitude: locationResponse?.results.first(where: { $0.id == firstSpotID })?.longitude ?? 0,
                            destinationName: locationResponse?.results.first(where: { $0.id == firstSpotID })?.name ?? "도착 지점"
                        )
                    ) {
                        Image(systemName: "location.north.fill").rotationEffect(.degrees(180))
                            .frame(width: 25)
                            .padding(.top, 1)
                            .padding(.bottom, 5)
                            .padding(.horizontal, 22)
                    }
                    // 첫 번째 관광지 표시
                    Text("\(locationResponse?.results.first(where: { $0.id == firstSpotID })?.name ?? "")")
                        .font(.system(size: 22))
                        .foregroundColor(Color(hex: 0xF73E6C))
                        .bold()
                        .padding(.horizontal, 10)
                }
                
                // 연속하는 관광지 간의 경로 표시
                ForEach(0..<spotArray.count - 1, id: \.self) { index in
                    let sourceSpotID = spotArray[index]
                    let destinationSpotID = spotArray[index + 1]
                    
                    NavigationLink(
                        destination: PlanRoutes(
                            sourceLatitude: locationResponse?.results.first(where: { $0.id == sourceSpotID })?.latitude ?? 0,
                            sourceLongitude: locationResponse?.results.first(where: { $0.id == sourceSpotID })?.longitude ?? 0,
                            sourceName: locationResponse?.results.first(where: { $0.id == sourceSpotID })?.name ?? "출발 지점",
                            destinationLatitude: locationResponse?.results.first(where: { $0.id == destinationSpotID })?.latitude ?? 0,
                            destinationLongitude: locationResponse?.results.first(where: { $0.id == destinationSpotID })?.longitude ?? 0,
                            destinationName: locationResponse?.results.first(where: { $0.id == destinationSpotID })?.name ?? "도착 지점"
                        )
                    ) {
                        Image(systemName: "location.north.fill").rotationEffect(.degrees(180))
                            .frame(width: 25)
                            .padding(.top, 1)
                            .padding(.bottom, 5)
                            .padding(.horizontal, 22)
                    }
                    // 도착 지점 표시
                    Text("\(locationResponse?.results.first(where: { $0.id == destinationSpotID })?.name ?? "")")
                        .font(.system(size: 22))
                        .foregroundColor(Color(hex: 0xF73E6C))
                        .bold()
                        .padding(.horizontal, 10)
                }
                
                // 마지막 관광지와 도착 지점(숙소) 간의 경로 표시
                if let lastSpotID = spotArray.last {
                    NavigationLink(
                        destination: PlanRoutes(
                            sourceLatitude: locationResponse?.results.first(where: { $0.id == lastSpotID })?.latitude ?? 0,
                            sourceLongitude: locationResponse?.results.first(where: { $0.id == lastSpotID })?.longitude ?? 0,
                            sourceName: locationResponse?.results.first(where: { $0.id == lastSpotID })?.name ?? "출발 지점",
                            destinationLatitude: locationResponse?.results.first(where: { $0.id == plan.accommodation })?.latitude ?? 0,
                            destinationLongitude: locationResponse?.results.first(where: { $0.id == plan.accommodation })?.longitude ?? 0,
                            destinationName: locationResponse?.results.first(where: { $0.id == plan.accommodation })?.name ?? "도착 지점"
                        )
                    ) {
                        Image(systemName: "location.north.fill").rotationEffect(.degrees(180))
                            .frame(width: 25)
                            .padding(.top, 1)
                            .padding(.bottom, 5)
                            .padding(.horizontal, 22)
                    }
                    // 도착 지점 표시
                    Text("\(locationResponse?.results.first(where: { $0.id == plan.accommodation })?.name ?? "")")
                        .font(.system(size: 22))
                        .foregroundColor(Color(hex: 0xF73E6C))
                        .bold()
                        .padding(.horizontal, 10)
                        .padding(.bottom, 10)
                }
            }
            .toolbar {
                ToolbarItem {
                    // 더보기 메뉴 아이템 (현재 기능 없음)
                    Menu {} label: {
                        Label("Menu", systemImage: "ellipsis.circle")
                    }
                }
            }
            .navigationBarTitle("\(plan.name)", displayMode: .inline)
        }
        .onAppear {
            Task {
                locationResponse = await loadData(target: "accommodation", id: plan.accommodation)
                await loadSpotCoordinates()
                updateRegionWithCoordinates()
            }
        }
    }
    
    // 관광지의 좌표를 비동기로 가져오는 함수
    func loadSpotCoordinates() async {
        for spotID in spotArray {
            let spotResponse = await loadData(target: "tourist_spot", id: spotID)
            locationResponse?.results.append(contentsOf: spotResponse.results)
        }
    }
    
    // 지도 리전을 관광지의 평균 좌표로 업데이트하는 함수
    func updateRegionWithCoordinates() {
        guard let locationResponse = locationResponse, !locationResponse.results.isEmpty else {
            return
        }
        
        // 관광지의 평균 좌표 계산
        let averageLatitude = locationResponse.results.reduce(0.0) { $0 + $1.latitude } / Double(locationResponse.results.count)
        let averageLongitude = locationResponse.results.reduce(0.0) { $0 + $1.longitude } / Double(locationResponse.results.count)
        
        // 지도에 모든 위치를 포함하도록 리전 계산
        let maxLatitude = locationResponse.results.max(by: { $0.latitude < $1.latitude })?.latitude ?? averageLatitude
        let minLatitude = locationResponse.results.min(by: { $0.latitude < $1.latitude })?.latitude ?? averageLatitude
        let maxLongitude = locationResponse.results.max(by: { $0.longitude < $1.longitude })?.longitude ?? averageLongitude
        let minLongitude = locationResponse.results.min(by: { $0.longitude < $1.longitude })?.longitude ?? averageLongitude
        
        let span = MKCoordinateSpan(
            latitudeDelta: abs(maxLatitude - minLatitude) * 1.4, // 패딩 추가
            longitudeDelta: abs(maxLongitude - minLongitude) * 1.4
        )
        
        region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: averageLatitude, longitude: averageLongitude),
            span: span
        )
    }
    
    // 서버에서 위치 정보를 비동기로 가져오는 함수
    func loadData(target: String, id: Int) async -> LocationResponse {
        guard let url = URL(string: "http://localhost:5500/api/\(target)/identification/\(id)") else {
            print("Invalid URL")
            return LocationResponse(results: [])
        }
        
        do {
            let (data, meta) = try await URLSession.shared.data(from: url)
            print(meta)
            do {
                let decodedResponse = try JSONDecoder().decode(LocationResponse.self, from: data)
                return decodedResponse
            } catch let jsonError as NSError {
                print("JSON decode failed: \(jsonError.localizedDescription)")
                return LocationResponse(results: [])
            }
        } catch {
            print("Invalid data")
            return LocationResponse(results: [])
        }
    }
    
    // 추가적인 지도 주석 항목을 반환하는 함수
    private func additionalAnnotations() -> [AnnotationItem] {
        guard let locationResponse = locationResponse else {
            return []
        }
        
        return locationResponse.results.map {
            AnnotationItem(coordinate: CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude), name: $0.name)
        }
    }
}
