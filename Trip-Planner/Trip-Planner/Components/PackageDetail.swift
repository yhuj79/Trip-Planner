import SwiftUI

struct PackageDetail: View {
    var package: PackageResult
    @State private var showAlert = false
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {
                AsyncImage(url: package.image_url)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width, height: 250)
                    .clipped()
                    .overlay (
                        Rectangle()
                            .fill(Color.black.opacity(0.05))
                    )
                HStack {
                    Text(package.name)
                        .bold()
                        .font(.system(size: 27))
                    Spacer()
                    Link(destination: URL(string: "\(package.link)")!)
                    {
                        Image(systemName: "link.circle.fill")
                            .font(.system(size: 16))
                        Text("예약 링크")
                            .font(.system(size: 16))
                    }
                }
                .padding(15)
                Text(package.description)
                    .font(.system(size: 16))
                    .padding(15)
                HStack {
                    HStack {
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
                    Spacer()
                    Text("₩ \(package.price)")
                        .font(.system(size: 25))
                        .bold()
                }
                .padding(12)
                HStack {
                    Image(systemName: "checkmark.seal.fill")
                    Text("상품 안내")
                }
                .foregroundColor(Color(hex: 0x5D5D5D))
                .padding(10)
                VStack(alignment: .leading) {
                    HStack {
                        Text("여행 기간 : ")
                        Text("\(package.date_range)")
                            .foregroundColor(Color(hex: 0x22741C))
                            .bold()
                    }
                    Spacer()
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
            .toolbar {
                ToolbarItem {
                    Menu {
                        Section("\(package.name)") {
                            Button {
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
            .alert(isPresented: $showAlert) {
                Alert(title: Text("위시리스트"), message: Text("\(package.wish != 0 ? "삭제가 완료되었습니다." : "등록이 완료되었습니다.")"))
            }
            .navigationBarTitle("패키지 정보", displayMode: .inline)
        }
    }
    
    func updateWishPackage() {
        Task {
            do {
                guard let url = URL(string: "http://localhost:5500/api/package/wish/update/\(package.wish == 1 ? 0 : 1)/\(package.id)") else {
                    print("Invalid URL")
                    return
                }
                
                let (_, meta) = try await URLSession.shared.data(from: url)
                print(meta)
                showAlert.toggle()
                
            } catch {
                print("Invalid data")
            }
        }
    }
}
