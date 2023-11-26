import SwiftUI

struct TSpotResponse: Codable {
    var results: [TSpotResult]
}

struct TSpotResult: Codable, Identifiable {
    let id: Int
    let name: String
    let intl_name: String
    let latitude: Double
    let longitude: Double
    let country: String
    let city_name: String
    let image_url: String
    let description: String
    let wish: Int
}

struct TSpot: View {
    @State private var results = [TSpotResult]()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("주요 관광지")
                .foregroundColor(Color.black)
                .font(.system(size: 22))
                .bold()
                .padding(.top, 10)
                .padding(.leading, 15)
                .padding(.bottom, -7)
            LazyVGrid(columns: Array(repeating: GridItem(), count: 2), spacing: 4) {
                ForEach(results) { spot in
                    NavigationLink(destination: TSpotDetail(spot: spot)) {
                        ZStack(alignment: .topLeading) {
                            RemoteImage(url: spot.image_url)
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 180, height: 138)
                                .clipped()
                            VStack(alignment: .leading) {
                                Text(spot.name)
                                    .font(.system(size: 20))
                                    .bold()
                                    .foregroundColor(Color.white)
                            }.padding(10)
                            HStack {
                                Spacer()
                                VStack {
                                    Spacer()
                                    Text("\(spot.country) \(spot.city_name)")
                                        .font(.subheadline)
                                        .bold()
                                        .foregroundColor(Color.white)
                                }
                            }.padding(10)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .padding(4)
                    }
                }
            }
            .padding(9)
            .onAppear {
                Task {
                    await loadData()
                }
            }
        }
    }
    
    func loadData() async {
        guard let url = URL(string: "http://localhost:5500/api/tourist_spot") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, meta) = try await URLSession.shared.data(from: url)
            print(meta)
            do {
                let decodedResponse = try JSONDecoder().decode(TSpotResponse.self, from: data)
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
    
    struct RemoteImage: View {
        private let url: String
        
        init(url: String) {
            self.url = url
        }
        
        var body: some View {
            if let imageUrl = URL(string: url), let imageData = try? Data(contentsOf: imageUrl), let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                Rectangle()
                    .fill(Color.black.opacity(0.25))
            } else {
                Image(systemName: "photo")
                    .resizable()
            }
        }
    }
}

#Preview {
    TSpot()
}
