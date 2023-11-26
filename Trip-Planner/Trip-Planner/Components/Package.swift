import SwiftUI

struct Response: Codable {
    var results: [Result]
}

struct Result: Codable, Identifiable {
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
    @State private var results = [Result]()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("추천 여행지")
                .foregroundColor(Color.black)
                .font(.system(size: 22))
                .bold()
                .padding(.top, 10)
                .padding(.leading, 15)
                .padding(.bottom, -7)
            LazyVGrid(columns: Array(repeating: GridItem(), count: 2), spacing: 4) {
                ForEach(results) { package in
                    NavigationLink(destination: PackageDetail(package: package)) {
                        ZStack(alignment: .topLeading) {
                            PackageImage(url: package.image_url)
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 180, height: 138)
                                .clipped()
                            VStack(alignment: .leading) {
                                Text(truncateName(package.name))
                                    .font(.system(size: 20))
                                    .bold()
                                    .foregroundColor(Color.white)
                                Text(package.date_range)
                                    .font(.system(size: 16))
                                    .bold()
                                    .foregroundColor(Color.white)
                            }.padding(10)
                            HStack {
                                Spacer()
                                VStack {
                                    Spacer()
                                    Text("₩ \(package.price)")
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
        guard let url = URL(string: "http://localhost:5500/api/package") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, meta) = try await URLSession.shared.data(from: url)
            print(meta)
            do {
                let decodedResponse = try JSONDecoder().decode(Response.self, from: data)
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

struct PackageImage: View {
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

func truncateName(_ name: String) -> String {
    guard let firstSpaceIndex = name.firstIndex(of: " ") else {
        return name
    }
    return String(name[..<firstSpaceIndex])
}

#Preview {
    Package()
}