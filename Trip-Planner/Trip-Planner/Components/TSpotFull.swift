import SwiftUI

// 전체 관광지 리스트를 표시하는 TSpotFull View
struct TSpotFull: View {
    // 관광지 목록을 담는 속성
    var results: [TSpotResult]
    
    var body: some View {
        // 수직 ScrollView를 사용하여 UI 구성
        ScrollView {
            // 수직 LazyVStack을 사용하여 관광지 목록 표시
            LazyVStack(alignment: .leading) {
                // 수직 LazyVGrid을 사용하여 관광지 목록을 그리드 형태로 표시
                LazyVGrid(columns: Array(repeating: GridItem(), count: 2), spacing: 4) {
                    // 관광지 목록을 순회하며 각 관광지를 클릭하면 상세 정보로 이동
                    ForEach(results) { spot in
                        NavigationLink(destination: TSpotDetail(spot: spot)) {
                            // 각 관광지의 이미지 및 정보를 표시하는 ZStack
                            ZStack(alignment: .topLeading) {
                                // 비동기 이미지 로딩을 지원하는 AsyncImage 컴포넌트
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
                // 네비게이션 바 타이틀 설정
                .navigationBarTitle("관광지 리스트")
                .padding(9)
            }
        }
    }
}

struct TSpotFull_Previews: PreviewProvider {
    static var previews: some View {
        TSpotFull(results: [])
    }
}
