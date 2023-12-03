import SwiftUI

struct AccommodationResponse: Codable {
    var results: [AccommodationResult]
}

// 각 숙소 정보를 담는 모델 정의
struct AccommodationResult: Codable, Identifiable {
    let id: Int
    let name: String
    let intl_name: String
    let latitude: Double
    let longitude: Double
    let price: Int
    let score: Double
    let country: String
    let city_name: String
    let link: String
    let image_url: String
    let description: String
    let wish: Int
}

// 숙소 목록을 나타내는 Accommodation View
struct Accommodation: View {
    // 숙소 정보 배열을 저장하는 속성
    @State private var results = [AccommodationResult]()
    
    var body: some View {
        // 수직 LazyVStack을 사용하여 UI 구성
        LazyVStack(alignment: .leading) {
            // 헤더 및 더보기 버튼 표시
            HStack {
                Text("추천 숙소")
                    .foregroundColor(Color.black)
                    .font(.system(size: 22))
                    .bold()
                    .padding(.top, 10)
                    .padding(.leading, 15)
                    .padding(.bottom, -5)
                Spacer()
                NavigationLink(destination: AccommodationFull(results: results)) {
                    Text("more")
                        .font(.system(size: 18))
                        .padding(.trailing, -3)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 18))
                        .padding(.top, 2)
                        .padding(.leading, -1)
                }
                .padding(.top, 10)
                .padding(.trailing, 15)
                .padding(.bottom, -5)
            }
            // 숙소 목록을 표시하는 수직 LazyVGrid
            LazyVGrid(columns: Array(repeating: GridItem(), count: 2), spacing: 4) {
                ForEach(results.prefix(4)) { accommodation in
                    NavigationLink(destination: AccommodationDetail(accommodation: accommodation)) {
                        // 각 숙소 아이템을 표시하는 ZStack
                        ZStack(alignment: .topLeading) {
                            // 숙소 이미지를 비동기적으로 로드하여 표시
                            AsyncImage(url: accommodation.image_url)
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 180, height: 135)
                                .clipped()
                                .overlay (
                                    Rectangle()
                                        .fill(Color.black.opacity(0.3))
                                )
                                .overlay(
                                    // 숙소 정보 텍스트 표시
                                    VStack(alignment: .leading) {
                                        Text(accommodation.name)
                                            .font(.system(size: 20))
                                            .bold()
                                            .foregroundColor(Color.white)
                                            .shadow(color: .black, radius: 0.7, x: 0.5, y: 0.5)
                                        Text("\(accommodation.country) \(accommodation.city_name)")
                                            .font(.subheadline)
                                            .bold()
                                            .foregroundColor(Color.white)
                                            .shadow(color: .black, radius: 0.7, x: 0.5, y: 0.5)
                                    }
                                        .padding(10),
                                    alignment: .topLeading
                                )
                                .overlay(
                                    // 별점 및 가격 정보 표시
                                    HStack {
                                        HStack {
                                            Image(systemName: "star.fill")
                                                .font(.system(size: 12))
                                                .bold()
                                                .foregroundColor(Color(hex: 0xFFE400))
                                            Text(String(format: "%.1f", accommodation.score))
                                                .shadow(color: .black, radius: 0.7, x: 0.5, y: 0.5)
                                                .font(.system(size: 14))
                                                .bold()
                                                .foregroundColor(Color(hex: 0xFFE400))
                                                .padding(.leading, -7)
                                        }
                                        Spacer()
                                        Text("₩ \(accommodation.price)")
                                            .font(.subheadline)
                                            .bold()
                                            .foregroundColor(Color.white)
                                            .shadow(color: .black, radius: 0.7, x: 0.5, y: 0.5)
                                    }
                                        .padding(10), alignment: .bottomTrailing
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                                .padding(4)
                        }
                    }
                }
            }
            .padding(9)
            .onAppear {
                // 데이터 로드를 비동기적으로 수행
                Task {
                    await loadData()
                }
            }
        }
    }
    
    // 서버에서 데이터를 비동기적으로 로드하는 함수
    func loadData() async {
        guard let url = URL(string: "http://localhost:5500/api/accommodation") else {
            print("Invalid URL")
            return
        }
        
        do {
            // 서버에서 데이터와 메타데이터를 비동기적으로 로드
            let (data, meta) = try await URLSession.shared.data(from: url)
            print(meta)
            do {
                // JSON 디코딩을 비동기적으로 수행
                let decodedResponse = try JSONDecoder().decode(AccommodationResponse.self, from: data)
                DispatchQueue.main.async {
                    // 메인 스레드에서 UI 업데이트
                    self.results = decodedResponse.results
                }
            } catch let jsonError as NSError {
                print("JSON decode failed: \(jsonError.localizedDescription)")
            }
        } catch {
            print("Invalid data")
        }
    }
}

struct Accommodation_Previews: PreviewProvider {
    static var previews: some View {
        Accommodation()
    }
}
