import SwiftUI

// 모든 여행 패키지를 표시하는 PackageFull View
struct PackageFull: View {
    // 패키지 목록을 받아오는 속성
    var results: [PackageResult]
    
    var body: some View {
        // 스크롤이 가능한 뷰로 감싸기
        ScrollView {
            // 수직 LazyVStack을 사용하여 UI 구성
            LazyVStack(alignment: .leading) {
                // 수직 LazyVGrid을 사용하여 패키지 목록 표시
                LazyVGrid(columns: Array(repeating: GridItem(), count: 2), spacing: 4) {
                    // 패키지 목록을 순회하며 각 관광지를 클릭하면 상세 정보로 이동
                    ForEach(results) { package in
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
                // 네비게이션 바 타이틀 및 패딩 설정
                .navigationBarTitle("패키지 리스트")
                .padding(9)
            }
        }
    }
}

struct PackageFull_Previews: PreviewProvider {
    static var previews: some View {
        PackageFull(results: [])
    }
}
