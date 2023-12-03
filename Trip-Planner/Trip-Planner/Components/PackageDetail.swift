import SwiftUI

// 여행 패키지 상세 정보를 표시하는 PackageDetail View
struct PackageDetail: View {
    // 패키지 정보를 받아오는 속성
    var package: PackageResult
    
    // 패키지 위시리스트 등록/삭제를 알리는 Alert 상태 변수
    @State private var showAlert = false
    
    var body: some View {
        // 스크롤이 가능한 뷰로 감싸기
        ScrollView {
            // 수직 LazyVStack을 사용하여 UI 구성
            LazyVStack(alignment: .leading, spacing: 0) {
                // AsyncImage를 사용하여 패키지 이미지 표시
                AsyncImage(url: package.image_url)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width, height: 250)
                    .clipped()
                    .overlay (
                        Rectangle()
                            .fill(Color.black.opacity(0.05))
                    )
                
                // 패키지 정보 표시를 위한 HStack
                HStack {
                    // 패키지 이름 및 예약 링크 버튼
                    Text(package.name)
                        .bold()
                        .font(.system(size: 27))
                    Spacer()
                    Link(destination: URL(string: "\(package.link)")!) {
                        Image(systemName: "link.circle.fill")
                            .font(.system(size: 16))
                        Text("예약 링크")
                            .font(.system(size: 16))
                    }
                }
                .padding(15)
                
                // 패키지 설명 텍스트
                Text(package.description)
                    .font(.system(size: 16))
                    .padding(15)
                
                // 패키지 국가, 가격 및 특징 표시를 위한 HStack
                HStack {
                    HStack {
                        // 국가 이미지 및 이름
                        Image("\(package.country)")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30)
                            .padding(10)
                        
                        Text(package.country)
                            .font(.system(size: 18))
                            .bold()
                            .padding(10)
                    }
                    .background(Color.black.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    // 가격 표시
                    Spacer()
                    Text("₩ \(package.price)")
                        .font(.system(size: 25))
                        .bold()
                }
                .padding(12)
                
                // 패키지 안내 아이콘 및 텍스트
                HStack {
                    Image(systemName: "checkmark.seal.fill")
                    Text("상품 안내")
                }
                .foregroundColor(Color(hex: 0x5D5D5D))
                .padding(10)
                
                // 패키지 안내 내용 표시를 위한 VStack
                VStack(alignment: .leading) {
                    // 여행 기간 텍스트
                    HStack {
                        Text("여행 기간 : ")
                        Text("\(package.date_range)")
                            .foregroundColor(Color(hex: 0x22741C))
                            .bold()
                    }
                    Spacer()
                    // 상품 안내 문구들
                    Text("예약시점에 따라 원가인상(항공, 호텔)으로 인해 상품가격이 변경될 수 있으며, 예약시 상품가격이 적용됩니다.")
                    Spacer()
                    Text("유류할증료는 매월 변경되며, 항공권 발권일의 유류할증료가 확정 유류할증료입니다.")
                    Spacer()
                    Text("여행경보 단계는 여행유의/자제/제한/금지 4단계로 구분되며, 외교부 '해외안전여행' 사이트 (www.0404.go.kr) 에서 상세정보를 확인할 수 있습니다.")
                    Spacer()
                    Text("1인 객실 사용시 추가요금이 발생됩니다.")
                }
                .font(.subheadline)
                .foregroundColor(Color(hex: 0x5D5D5D))
                .padding(15)
            }
            // 패키지 위시리스트 등록/삭제 메뉴 및 패딩 설정
            .toolbar {
                ToolbarItem {
                    Menu {
                        Section("\(package.name)") {
                            Button {
                                // 패키지 위시리스트 업데이트 메서드 호출
                                updateWishPackage()
                            } label: {
                                Label("위시리스트 \(package.wish != 0 ? "삭제" : "등록")", systemImage: "\(package.wish != 0 ? "heart.fill" : "heart")")
                            }
                        }
                    } label: {
                        Label("Menu", systemImage: "ellipsis.circle")
                    }
                }
            }
            // 패키지 위시리스트 알림 설정
            .alert(isPresented: $showAlert) {
                Alert(title: Text("위시리스트"), message: Text("\(package.wish != 0 ? "삭제가 완료되었습니다." : "등록이 완료되었습니다.")"))
            }
            // 네비게이션 바 타이틀 설정
            .navigationBarTitle("패키지 정보", displayMode: .inline)
        }
    }
    
    // 패키지 위시리스트 업데이트 메서드 정의
    func updateWishPackage() {
        Task {
            do {
                // API 엔드포인트 URL 생성
                guard let url = URL(string: "http://localhost:5500/api/package/wish/update/\(package.wish == 1 ? 0 : 1)/\(package.id)") else {
                    print("Invalid URL")
                    return
                }
                
                // API로 패키지 위시리스트 업데이트 요청
                let (_, meta) = try await URLSession.shared.data(from: url)
                print(meta)
                
                // 알림 표시
                showAlert.toggle()
                
            } catch {
                print("Invalid data")
            }
        }
    }
}
