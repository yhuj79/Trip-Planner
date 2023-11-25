import SwiftUI

struct WishPackageResponse: Codable {
    var results: [Result]
}

struct WishPackageResult: Codable, Identifiable {
    let id: Int
    let name: String
    let country: String
    let price: Int
    let category: String
    let date_range: String
    let link: String
    let image_url: String
    let description: String
    let wish: Int
}

struct WishView: View {
    @State private var results = [Result]()
    
    var body: some View {
        NavigationView {
            List(results) { package in
                NavigationLink(destination: PackageDetailView(package: package)) {
                    HStack {
                        AsyncImage(url: URL(string: package.image_url))
                            .frame(width: 50, height: 50)
                            .cornerRadius(8)
                        VStack(alignment: .leading) {
                            Text(package.name)
                                .font(.system(size: 14))
                                .bold()
                                .padding(.bottom, 1)
                            Text(package.date_range)
                                .foregroundColor(.gray)
                                .font(.system(size: 14))
                        }
                        Spacer()
                        Text("₩ \(package.price)")
                            .font(.system(size: 12))
                    }
                    .navigationBarTitle("위시리스트")
                }
                .padding(.horizontal, -7)
            }
        }
        .onAppear {
            Task {
                await loadData()
            }
        }
    }
    
    func loadData() async {
        guard let url = URL(string: "http://localhost:5500/api/package/wish") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, meta) = try await URLSession.shared.data(from: url)
            print(meta)
            do {
                let decodedResponse = try JSONDecoder().decode(WishPackageResponse.self, from: data)
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
    WishView()
}
