import SwiftUI

// 위시리스트에 저장된 패키지 정보를 표시하는 뷰 정의
struct WishPackageResponse: Codable {
    var results: [PackageResult]
}

// 패키지 결과를 표현하는 모델
struct WishPackageResult: Codable, Identifiable {
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

// 위시리스트에 저장된 패키지를 표시하는 뷰
struct WishPackage: View {
    // 위시리스트에 저장된 패키지 정보를 담을 배열
    @State private var results = [PackageResult]()
    
    var body: some View {
        // 수직 LazyVStack을 사용하여 UI 구성
        LazyVStack(alignment: .leading) {
            // 섹션 제목 표시
            Text("패키지")
                .foregroundColor(Color.black)
                .font(.system(size: 22))
                .bold()
                .padding(.top, 18)
                .padding(.leading, 18)
                .padding(.bottom, -5)
            
            // 수평 LazyVGrid를 사용하여 패키지 목록 표시
            LazyVGrid(columns: Array(repeating: GridItem(), count: 1), spacing: 4) {
                // 패키지 정보를 순회하며 표시
                ForEach(results) { package in
                    NavigationLink(destination: PackageDetail(package: package)) {
                        // 패키지 정보를 나타내는 HStack
                        HStack {
                            // 비동기 이미지 로딩을 지원하는 AsyncImage 컴포넌트
                            AsyncImage(url: package.image_url)
                                .frame(width: 50, height: 50)
                                .cornerRadius(8)
                                .overlay (
                                    Rectangle()
                                        .fill(Color.black.opacity(0.05))
                                        .cornerRadius(8)
                                )
                            
                            // 패키지 이름과 기간을 나타내는 VStack
                            VStack(alignment: .leading) {
                                Text(package.name)
                                    .font(.system(size: 14))
                                    .bold()
                                    .padding(.bottom, 1)
                                Text(package.date_range)
                                    .font(.system(size: 12))
                            }
                            Spacer()
                            
                            // 패키지 가격을 나타내는 텍스트
                            Text("₩ \(package.price)")
                                .font(.system(size: 12))
                        }
                        .padding(7)
                    }
                    .background(Color.white)
                    .foregroundColor(Color.black)
                    .cornerRadius(10)
                    .shadow(color: .gray, radius: 2, x: 1, y: 1)
                    .padding(.horizontal, 12)
                    .padding(.bottom, 2)
                }
            }
            .padding(10)
            
            // 뷰가 나타날 때 데이터를 비동기적으로 로드
            .onAppear {
                Task {
                    await loadData()
                }
            }
        }
    }
    
    // API를 통해 위시리스트에 저장된 패키지 정보를 비동기적으로 로드
    func loadData() async {
        guard let url = URL(string: "http://localhost:5500/api/package/wish") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, meta) = try await URLSession.shared.data(from: url)
            print(meta)
            do {
                let decodedResponse = try JSONDecoder().decode(WishPackageResponse.self, from: data)
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

#Preview {
    WishPackage()
}
