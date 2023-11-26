import SwiftUI

struct WishTSpotResponse: Codable {
    var results: [TSpotResult]
}

struct WishTSpotResult: Codable, Identifiable {
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

struct WishTSpot: View {
    @State private var results = [TSpotResult]()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("관광지")
                .foregroundColor(Color.black)
                .font(.system(size: 22))
                .bold()
                .padding(.top, 10)
                .padding(.leading, 18)
                .padding(.bottom, -5)
            LazyVGrid(columns: Array(repeating: GridItem(), count: 1), spacing: 4) {
                ForEach(results) { spot in
                    NavigationLink(destination: TSpotDetail(spot: spot)) {
                        HStack {
                            WishTSpotImage(url: spot.image_url)
                                .frame(width: 50, height: 50)
                                .cornerRadius(8)
                            VStack(alignment: .leading) {
                                Text(spot.name)
                                    .font(.system(size: 14))
                                    .bold()
                                    .padding(.bottom, 1)
                                Text(spot.intl_name)
                                    .font(.system(size: 12))
                            }
                            Spacer()
                            Text("\(spot.country) \(spot.city_name)")
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
            .onAppear {
                Task {
                    await loadData()
                }
            }
        }
    }
    
    func loadData() async {
        guard let url = URL(string: "http://localhost:5500/api/tourist_spot/wish") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, meta) = try await URLSession.shared.data(from: url)
            print(meta)
            do {
                let decodedResponse = try JSONDecoder().decode(WishTSpotResponse.self, from: data)
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

struct WishTSpotImage: View {
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

#Preview {
    WishTSpot()
}
