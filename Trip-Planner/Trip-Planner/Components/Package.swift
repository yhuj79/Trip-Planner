import SwiftUI

struct PackageResponse: Codable {
    var results: [PackageResult]
}

struct PackageResult: Codable, Identifiable {
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

struct Package: View {
    @State private var results = [PackageResult]()
    
    var body: some View {
        LazyVStack(alignment: .leading) {
            HStack {
                Text("추천 여행지")
                    .foregroundColor(Color.black)
                    .font(.system(size: 22))
                    .bold()
                    .padding(.top, 18)
                    .padding(.leading, 15)
                    .padding(.bottom, -5)
                Spacer()
                NavigationLink(destination: PackageFull(results: results)) {
                    Text("more")
                        .font(.system(size: 18))
                        .padding(.trailing, -3)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 18))
                        .padding(.top, 2)
                        .padding(.leading, -1)
                }
                .padding(.top, 18)
                .padding(.trailing, 15)
                .padding(.bottom, -5)
            }
            LazyVGrid(columns: Array(repeating: GridItem(), count: 2), spacing: 4) {
                ForEach(results.prefix(4)) { package in
                    NavigationLink(destination: PackageDetail(package: package)) {
                        ZStack(alignment: .topLeading) {
                            AsyncImage(url: package.image_url)
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 180, height: 135)
                                .clipped()
                                .overlay (
                                    Rectangle()
                                        .fill(Color.black.opacity(0.25))
                                )
                                .overlay(
                                    VStack(alignment: .leading) {
                                        Text(package.country)
                                            .font(.system(size: 20))
                                            .bold()
                                            .foregroundColor(Color.white)
                                            .shadow(color: .black, radius: 0.7, x: 0.5, y: 0.5)
                                        Text(package.date_range)
                                            .font(.system(size: 16))
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
                                            Text("₩ \(package.price)")
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
        guard let url = URL(string: "http://localhost:5500/api/package") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, meta) = try await URLSession.shared.data(from: url)
            print(meta)
            do {
                let decodedResponse = try JSONDecoder().decode(PackageResponse.self, from: data)
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

struct Package_Previews: PreviewProvider {
    static var previews: some View {
        Package()
    }
}
