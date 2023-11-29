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
        LazyVStack(alignment: .leading) {
            HStack {
                Text("주요 관광지")
                    .foregroundColor(Color.black)
                    .font(.system(size: 22))
                    .bold()
                    .padding(.top, 10)
                    .padding(.leading, 15)
                    .padding(.bottom, -5)
                Spacer()
                NavigationLink(destination: TSpotFull(results: results)) {
                    Text("더보기")
                        .font(.system(size: 18))
                        .padding(.trailing, -3)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 18))
                }
                .padding(.top, 10)
                .padding(.trailing, 15)
                .padding(.bottom, -5)
            }
            LazyVGrid(columns: Array(repeating: GridItem(), count: 2), spacing: 4) {
                ForEach(results.prefix(4)) { spot in
                    NavigationLink(destination: TSpotDetail(spot: spot)) {
                        ZStack(alignment: .topLeading) {
                            AsyncImage(url: spot.image_url)
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 180, height: 135)
                                .clipped()
                                .overlay (
                                    Rectangle()
                                        .fill(Color.black.opacity(0.25))
                                )
                                .overlay(
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
}

struct TSpot_Previews: PreviewProvider {
    static var previews: some View {
        TSpot()
    }
}
