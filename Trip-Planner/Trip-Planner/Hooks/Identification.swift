import SwiftUI

struct IdentificationResponse: Codable {
    var results: [IdentificationResult]
}

struct IdentificationResult: Codable, Identifiable {
    let id: Int
    let name: String
}

struct Identification: View {
    let id: Int
    let target: String
    @State private var results = [IdentificationResult]()
    
    var body: some View {
        VStack {
            ForEach(results) { p in
                Text("\(p.name)")
            }
        }
        .onAppear {
            Task {
                await loadData()
            }
        }
    }
    
    func loadData() async {
        guard let url = URL(string: "http://localhost:5500/api/\(target)/identification/\(id)") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, meta) = try await URLSession.shared.data(from: url)
            print(meta)
            do {
                let decodedResponse = try JSONDecoder().decode(IdentificationResponse.self, from: data)
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
