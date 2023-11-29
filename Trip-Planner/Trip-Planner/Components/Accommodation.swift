import SwiftUI

struct AccommodationResponse: Codable {
    var results: [AccommodationResult]
}

struct AccommodationResult: Codable, Identifiable {
    let id: Int
    let name: String
    let intl_name: String
    let latitude: Double
    let longitude: Double
    let price: Int
    let score: Double
    let country: String
    let city_name: String
    let link: String
    let image_url: String
    let description: String
    let wish: Int
}

struct Accommodation: View {
    @State private var results = [AccommodationResult]()
    
    var body: some View {
        LazyVStack(alignment: .leading) {
            HStack {
                Text("추천 숙소")
                    .foregroundColor(Color.black)
                    .font(.system(size: 22))
                    .bold()
                    .padding(.top, 10)
                    .padding(.leading, 15)
                    .padding(.bottom, -5)
                Spacer()
                NavigationLink(destination: AccommodationFull(results: results)) {
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
                ForEach(results.prefix(4)) { accommodation in
                    NavigationLink(destination: AccommodationDetail(accommodation: accommodation)) {
                        ZStack(alignment: .topLeading) {
                            AsyncImage(url: accommodation.image_url)
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 180, height: 135)
                                .clipped()
                                .overlay (
                                    Rectangle()
                                        .fill(Color.black.opacity(0.3))
                                )
                                .overlay(
                                    VStack(alignment: .leading) {
                                        Text(accommodation.name)
                                            .font(.system(size: 17))
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
            .padding(9)
            .onAppear {
                Task {
                    await loadData()
                }
            }
        }
    }
    
    func loadData() async {
        guard let url = URL(string: "http://localhost:5500/api/accommodation") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, meta) = try await URLSession.shared.data(from: url)
            print(meta)
            do {
                let decodedResponse = try JSONDecoder().decode(AccommodationResponse.self, from: data)
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

struct Accommodation_Previews: PreviewProvider {
    static var previews: some View {
        Accommodation()
    }
}
