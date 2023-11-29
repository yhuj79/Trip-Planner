import SwiftUI
import MapKit

struct TSpotDetail: View {
    var spot: TSpotResult
    @State private var showAlert = false
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {
                AsyncImage(url: spot.image_url)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width, height: 250)
                    .clipped()
                    .overlay (
                        Rectangle()
                            .fill(Color.black.opacity(0.05))
                    )
                VStack(alignment: .leading) {
                    Text(spot.name)
                        .bold()
                        .font(.system(size: 27))
                        .padding(.bottom, 1)
                    Text(spot.intl_name)
                        .bold()
                        .font(.system(size: 18))
                        .foregroundColor(Color(hex: 0x5D5D5D))
                }
                .padding(.horizontal, 13)
                .padding(.top, 13)
                .padding(.bottom, 3)
                Text(spot.description)
                    .font(.system(size: 16))
                    .padding(15)
                HStack {
                    HStack {
                        Image("\(spot.country)")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30)
                            .padding(10)
                        
                        Text("\(spot.country) \(spot.city_name)")
                            .font(.system(size: 18))
                            .bold()
                            .padding(10)
                    }
                    .background(Color.black.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    Spacer()
                    HStack {
                        Link(destination: URL(string: "https://ko.wikipedia.org/wiki/\(spot.name)")!)
                        {
                            Image(systemName: "doc.text.magnifyingglass")
                                .font(.system(size: 16))
                            Text("Wikipedia")
                                .font(.system(size: 16))
                        }
                        .foregroundColor(Color(hex: 0x4374D9))
                    }
                }
                .padding(12)
                NavigationLink(destination: MapView(title: spot.name, latitude: spot.latitude, longitude: spot.longitude)) {
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
                        Section("\(spot.name) (\(spot.intl_name))") {
                            Button {
                                updateWishTSpot()
                            } label: {
                                Label("위시리스트 \(spot.wish != 0 ? "삭제" : "등록")", systemImage: "\(spot.wish != 0 ? "heart.fill" : "heart")")
                            }
                        }
                    } label: {
                        Label("Menu", systemImage: "ellipsis.circle")
                    }
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("위시리스트"), message: Text("\(spot.wish != 0 ? "삭제가 완료되었습니다." : "등록이 완료되었습니다.")"))
            }
            .navigationBarTitle("관광지 정보", displayMode: .inline)
        }
    }
    
    private var region: MKCoordinateRegion {
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: spot.latitude, longitude: spot.longitude),
            span: MKCoordinateSpan(latitudeDelta: 0.007, longitudeDelta: 0.007)
        )
    }
    
    func updateWishTSpot() {
        Task {
            do {
                guard let url = URL(string: "http://localhost:5500/api/tourist_spot/wish/update/\(spot.wish == 1 ? 0 : 1)/\(spot.id)") else {
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
