import SwiftUI

struct WishAccommodationResponse: Codable {
    var results: [AccommodationResult]
}

struct WishAccommodationResult: Codable, Identifiable {
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

struct WishAccommodation: View {
    @State private var results = [AccommodationResult]()
    
    var body: some View {
        LazyVStack(alignment: .leading) {
            Text("숙소")
                .foregroundColor(Color.black)
                .font(.system(size: 22))
                .bold()
                .padding(.top, 10)
                .padding(.leading, 18)
                .padding(.bottom, -5)
            LazyVGrid(columns: Array(repeating: GridItem(), count: 1), spacing: 4) {
                ForEach(results) { accommodation in
                    NavigationLink(destination: AccommodationDetail(accommodation: accommodation)) {
                        HStack {
                            AsyncImage(url: accommodation.image_url)
                                .frame(width: 50, height: 50)
                                .cornerRadius(8)
                                .overlay (
                                    Rectangle()
                                        .fill(Color.black.opacity(0.05))
                                        .cornerRadius(8)
                                )
                            VStack(alignment: .leading) {
                                Text(accommodation.name)
                                    .font(.system(size: 14))
                                    .bold()
                                    .padding(.bottom, 1)
                                Text(accommodation.intl_name)
                                    .font(.system(size: 12))
                            }
                            Spacer()
                            Text("\(accommodation.country) \(accommodation.city_name)")
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
        guard let url = URL(string: "http://localhost:5500/api/accommodation/wish") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, meta) = try await URLSession.shared.data(from: url)
            print(meta)
            do {
                let decodedResponse = try JSONDecoder().decode(WishAccommodationResponse.self, from: data)
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

#Preview {
    WishAccommodation()
}
