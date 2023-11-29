import SwiftUI
import MapKit

struct AccommodationDetail: View {
    var accommodation: AccommodationResult
    @State private var showAlert = false
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {
                AsyncImage(url: accommodation.image_url)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width, height: 250)
                    .clipped()
                    .overlay (
                        Rectangle()
                            .fill(Color.black.opacity(0.05))
                    )
                    .overlay(
                        HStack {
                            HStack {
                                Image(systemName: "star.fill")
                                    .font(.system(size: 15))
                                    .bold()
                                    .foregroundColor(Color(hex: 0xFFE400))
                                Text(String(format: "%.1f", accommodation.score))
                                    .shadow(color: .black, radius: 0.7, x: 0.5, y: 0.5)
                                    .font(.system(size: 17))
                                    .bold()
                                    .foregroundColor(Color(hex: 0xFFE400))
                                    .padding(.leading, -7)
                            }
                            Spacer()
                        }
                            .padding(10), alignment: .bottomTrailing
                    )
                HStack {
                    VStack(alignment: .leading) {
                        Text(accommodation.name)
                            .bold()
                            .font(.system(size: 27))
                        Text(accommodation.intl_name)
                            .bold()
                            .font(.system(size: 18))
                            .foregroundColor(Color(hex: 0x5D5D5D))
                    }
                    Spacer()
                    Link(destination: URL(string: "\(accommodation.link)")!)
                    {
                        Image(systemName: "link.circle.fill")
                            .font(.system(size: 16))
                        Text("예약 링크")
                            .font(.system(size: 16))
                    }
                }
                .padding(15)
                Text(accommodation.description)
                    .font(.system(size: 16))
                    .padding(15)
                HStack {
                    HStack {
                        Image("\(accommodation.country)")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30)
                            .padding(10)
                        
                        Text("\(accommodation.country) \(accommodation.city_name)")
                            .font(.system(size: 18))
                            .bold()
                            .padding(10)
                    }
                    .background(Color.black.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("1박당 요금 시작가")
                            .font(.system(size: 12))
                            .bold()
                        Text("₩ \(accommodation.price)")
                            .font(.system(size: 22))
                            .bold()
                    }
                }
                .padding(12)
                HStack {
                    Image(systemName: "checkmark.seal.fill")
                    Text("상품 안내")
                }
                .foregroundColor(Color(hex: 0x5D5D5D))
                .padding(10)
                VStack(alignment: .leading) {
                    Text("아동 예약 시 아동에 대한 식사(라운지 이용 포함) 및 추가 침대는 불포함입니다.")
                    Spacer()
                    Text("객실당 3인 이상 예약 시 2인 기준으로 식사(라운지 이용 포함) 및 침대가 제공될 수 있습니다.")
                    Spacer()
                    Text("호텔의 자체적인 서비스(공항 픽업, 조식 추가 등)는 대행이 불가합니다. 호텔 예약 후 호텔로 별도 문의 바랍니다.")
                }
                .font(.subheadline)
                .foregroundColor(Color(hex: 0x5D5D5D))
                .padding(15)
                NavigationLink(destination: MapView(title: accommodation.name, latitude: accommodation.latitude, longitude: accommodation.longitude)) {
                    HStack {
                        Image(systemName: "map.circle")
                        Text("지도 전체화면으로 보기")
                    }
                }
                .foregroundColor(Color(hex: 0xF73E6C))
                .padding(10)
                Map(initialPosition: .region(region))
                    .frame(height: 250)
            }
            .toolbar {
                ToolbarItem {
                    Menu {
                        Section("\(accommodation.name)") {
                            Button {
                                updateWishAccommodation()
                            } label: {
                                Label("위시리스트 \(accommodation.wish != 0 ? "삭제" : "등록")", systemImage: "\(accommodation.wish != 0 ? "heart.fill" : "heart")")
                            }
                        }
                    } label: {
                        Label("Menu", systemImage: "ellipsis.circle")
                    }
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("위시리스트"), message: Text("\(accommodation.wish != 0 ? "삭제가 완료되었습니다." : "등록이 완료되었습니다.")"))
            }
            .navigationBarTitle("숙소 정보", displayMode: .inline)
        }
    }
    
    private var region: MKCoordinateRegion {
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: accommodation.latitude, longitude: accommodation.longitude),
            span: MKCoordinateSpan(latitudeDelta: 0.0012, longitudeDelta: 0.0012)
        )
    }
    
    func updateWishAccommodation() {
        Task {
            do {
                guard let url = URL(string: "http://localhost:5500/api/accommodation/wish/update/\(accommodation.wish == 1 ? 0 : 1)/\(accommodation.id)") else {
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
