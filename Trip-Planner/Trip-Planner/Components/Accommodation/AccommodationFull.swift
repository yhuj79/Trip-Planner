import SwiftUI

// 전체 숙소 목록을 표시하는 AccommodationFull View
struct AccommodationFull: View {
    // 숙소 정보 배열을 저장하는 속성
    var results: [AccommodationResult]
    
    var body: some View {
        // 수직 ScrollView 안에 수직 LazyVStack을 사용하여 UI 구성
        ScrollView {
            LazyVStack(alignment: .leading) {
                // 수평 LazyVGrid를 사용하여 2열의 그리드 형태로 숙소 목록 표시
                LazyVGrid(columns: Array(repeating: GridItem(), count: 2), spacing: 4) {
                    ForEach(results) { accommodation in
                        // 각 숙소를 터치하면 상세 정보가 표시되는 NavigationLink
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
                // 네비게이션 바 제목 및 여백 설정
                .navigationBarTitle("숙소 리스트")
                .padding(9)
            }
        }
    }
}

struct AccommodationFull_Previews: PreviewProvider {
    static var previews: some View {
        AccommodationFull(results: [])
    }
}
