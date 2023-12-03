import SwiftUI

// 관광지 목록 API 응답을 파싱하는 TSpotResponse 구조체 정의
struct TSpotResponse: Codable {
    var results: [TSpotResult]
}

// 관광지 정보를 담는 TSpotResult 구조체 정의
struct TSpotResult: Codable, Identifiable {
    let id: Int
    let name: String
    let intl_name: String
    let latitude: Double
    let longitude: Double
    let country: String
    let city_name: String
    let image_url: String
    let description: String
    let wish: Int
}

// 관광지 목록을 표시하는 TSpot View
struct TSpot: View {
    // 관광지 목록을 담는 속성
    @State private var results = [TSpotResult]()
    
    var body: some View {
        // 수직 LazyVStack을 사용하여 UI 구성
        LazyVStack(alignment: .leading) {
            // 타이틀과 더보기 링크를 표시하는 HStack
            HStack {
                Text("주요 관광지")
                    .foregroundColor(Color.black)
                    .font(.system(size: 22))
                    .bold()
                    .padding(.top, 10)
                    .padding(.leading, 15)
                    .padding(.bottom, -5)
                Spacer()
                // 더보기 링크를 클릭하면 모든 관광지를 표시하는 View로 이동
                NavigationLink(destination: TSpotFull(results: results)) {
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
            // 수직 LazyVGrid을 사용하여 관광지 목록 표시
            LazyVGrid(columns: Array(repeating: GridItem(), count: 2), spacing: 4) {
                ForEach(results.prefix(4)) { spot in
                    // 각 관광지를 클릭하면 TSpotDetail로 이동하는 NavigationLink
                    NavigationLink(destination: TSpotDetail(spot: spot)) {
                        // 관광지 이미지 및 정보를 표시하는 ZStack
                        ZStack(alignment: .topLeading) {
                            // 비동기 이미지 로딩을 지원하는 AsyncImage
                            AsyncImage(url: spot.image_url)
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 180, height: 135)
                                .clipped()
                                .overlay (
                                    Rectangle()
                                        .fill(Color.black.opacity(0.25))
                                )
                                .overlay(
                                    // 관광지 이름을 표시하는 VStack
                                    VStack(alignment: .leading) {
                                        Text(spot.name)
                                            .font(.system(size: 20))
                                            .bold()
                                            .foregroundColor(Color.white)
                                            .shadow(color: .black, radius: 0.7, x: 0.5, y: 0.5)
                                    }.padding(10),
                                    alignment: .topLeading
                                )
                                .overlay(
                                    // 국가와 도시 이름을 표시하는 HStack
                                    HStack {
                                        Spacer()
                                        VStack {
                                            Spacer()
                                            Text("\(spot.country) \(spot.city_name)")
                                                .font(.subheadline)
                                                .bold()
                                                .foregroundColor(Color.white)
                                                .shadow(color: .black, radius: 0.7, x: 0.5, y: 0.5)
                                        }
                                    }.padding(10),
                                    alignment: .bottomTrailing
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                                .padding(4)
                        }
                    }
                }
            }
            .padding(9)
            .onAppear {
                // 데이터 로딩을 위한 비동기 메서드 호출
                Task {
                    await loadData()
                }
            }
        }
    }
    
    // 관광지 목록을 서버에서 비동기로 로딩하는 메서드
    func loadData() async {
        guard let url = URL(string: "http://localhost:5500/api/tourist_spot") else {
            print("Invalid URL")
            return
        }
        
        do {
            // API에서 데이터를 비동기로 가져오기
            let (data, meta) = try await URLSession.shared.data(from: url)
            print(meta)
            do {
                // JSON 데이터를 디코딩하여 결과를 업데이트
                let decodedResponse = try JSONDecoder().decode(TSpotResponse.self, from: data)
                DispatchQueue.main.async {
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

struct TSpot_Previews: PreviewProvider {
    static var previews: some View {
        TSpot()
    }
}
