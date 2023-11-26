import SwiftUI
import MapKit

struct TSpotDetail: View {
    var spot: TSpotResult
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                ZStack {
                    TSpotImage(url: spot.image_url)
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 250)
                        .clipped()
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: {}) {
                                Image(systemName: spot.wish != 0 ? "star.fill" : "star")
                                    .font(.system(size: 25))
                                    .foregroundColor(spot.wish != 0 ? .yellow : .gray)
                                    .padding(7)
                            }
                            .background(Color.white)
                            .clipShape(Circle())
                            .padding(7)
                        }
                        Spacer()
                    }
                }
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
            .navigationBarTitle("관광지 정보", displayMode: .inline)
        }
    }
    
    private var region: MKCoordinateRegion {
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: spot.latitude, longitude: spot.longitude),
            span: MKCoordinateSpan(latitudeDelta: 0.007, longitudeDelta: 0.007)
        )
    }
}

struct TSpotImage: View {
    private let url: String
    
    init(url: String) {
        self.url = url
    }
    
    var body: some View {
        if let imageUrl = URL(string: url), let imageData = try? Data(contentsOf: imageUrl), let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage)
                .resizable()
        } else {
            Image(systemName: "photo")
                .resizable()
        }
    }
}
