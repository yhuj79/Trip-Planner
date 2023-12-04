import SwiftUI

// API 응답에서 사용할 PackageResponse 모델 정의
struct PackageResponse: Codable {
    var results: [PackageResult]
}

// 여행 패키지 정보를 담는 PackageResult 모델 정의
struct PackageResult: Codable, Identifiable {
    let id: Int
    let name: String
    let country: String
    let price: Int
    let category: String
    let date_range: String
    let link: String
    let image_url: String
    let description: String
    let wish: Int
}

// 여행 패키지 목록을 표시하는 Package View
struct Package: View {
    // API에서 받아온 패키지 정보를 저장하는 상태 변수
    @State private var results = [PackageResult]()
    
    var body: some View {
        // 수직 LazyVStack을 이용한 UI 구성
        LazyVStack(alignment: .leading) {
            // 패키지 섹션 헤더
            HStack {
                Text("추천 여행지")
                    .foregroundColor(Color.black)
                    .font(.system(size: 22))
                    .bold()
                    .padding(.top, 18)
                    .padding(.leading, 15)
                    .padding(.bottom, -5)
                Spacer()
                // 더보기 링크를 클릭하면 모든 여행 패키지를 표시하는 View로 이동
                NavigationLink(destination: PackageFull(results: results)) {
                    Text("more")
                        .font(.system(size: 18))
                        .padding(.trailing, -3)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 18))
                        .padding(.top, 2)
                        .padding(.leading, -1)
                }
                .padding(.top, 18)
                .padding(.trailing, 15)
                .padding(.bottom, -5)
            }
            
            // 수직 LazyVGrid을 사용하여 여행 패키지 목록 표시
            LazyVGrid(columns: Array(repeating: GridItem(), count: 2), spacing: 4) {
                ForEach(results.prefix(4)) { package in
                    // 각 패키지에 대한 NavigationLink
                    NavigationLink(destination: PackageDetail(package: package)) {
                        // 패키지 이미지와 정보를 표시하는 ZStack
                        ZStack(alignment: .topLeading) {
                            // 비동기 이미지 로딩을 지원하는 AsyncImage 컴포넌트
                            AsyncImage(url: package.image_url)
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 180, height: 135)
                                .clipped()
                                .overlay (
                                    Rectangle()
                                        .fill(Color.black.opacity(0.25))
                                )
                                .overlay(
                                    // 패키지 정보를 표시하는 VStack
                                    VStack(alignment: .leading) {
                                        Text(package.country)
                                            .font(.system(size: 20))
                                            .bold()
                                            .foregroundColor(Color.white)
                                            .shadow(color: .black, radius: 0.7, x: 0.5, y: 0.5)
                                        Text(package.date_range)
                                            .font(.system(size: 16))
                                            .bold()
                                            .foregroundColor(Color.white)
                                            .shadow(color: .black, radius: 0.7, x: 0.5, y: 0.5)
                                    }.padding(10),
                                    alignment: .topLeading
                                )
                                .overlay(
                                    // 패키지 가격을 표시하는 HStack
                                    HStack {
                                        Spacer()
                                        VStack {
                                            Spacer()
                                            Text("₩ \(package.price)")
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
            // 패키지 목록을 비동기로 불러오는 loadData 메서드 호출
            .onAppear {
                Task {
                    await loadData()
                }
            }
        }
    }
    
    // 패키지 목록을 비동기로 불러오는 loadData 메서드 정의
    func loadData() async {
        guard let url = URL(string: "http://localhost:5500/api/package") else {
            print("Invalid URL")
            return
        }
        
        do {
            // API에서 데이터 가져오기
            let (data, meta) = try await URLSession.shared.data(from: url)
            print(meta)
            do {
                // JSON 디코딩하여 패키지 목록 업데이트
                let decodedResponse = try JSONDecoder().decode(PackageResponse.self, from: data)
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

struct Package_Previews: PreviewProvider {
    static var previews: some View {
        Package()
    }
}
