import SwiftUI

struct PlanListResponse: Codable {
    var results: [PlanListResult]
}

struct PlanListResult: Codable, Identifiable {
    let id: Int
    let name: String
    let accommodation: Int
    let spot_list: String
    
    var spotArray: [Int] {
        return spot_list.components(separatedBy: "-").compactMap { Int($0) }
    }
}

struct PlanList: View {
    @State private var results = [PlanListResult]()
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: 1), spacing: 4) {
            if results.count == 0 {
                VStack {
                    Text("등록된 일정이 없습니다.")
                }
                .padding(.vertical, 100)
            }
            ForEach(results) { plan in
                NavigationLink(destination: PlanDetail(plan: plan, spotArray: plan.spotArray)) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(plan.name)
                                .font(.system(size: 16))
                                .bold()
                                .padding(.bottom, 2)
                            Identification(id: plan.accommodation, target: "accommodation")
                                .font(.system(size: 12))
                            ForEach(plan.spotArray.prefix(5), id: \.self) { id in
                                Identification(id: id, target: "tourist_spot")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                            }
                            if plan.spotArray.count > 5 {
                                Text("...")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(5)
                        Spacer()
                        Button(action: {}) {
                            Image(systemName: "slider.horizontal.3")
                        }
                        .font(.system(size: 18))
                        .frame(width: 36, height: 36)
                        .background(
                            Circle().fill(Color.white)
                        )
                        .shadow(color: .gray, radius: 0.8, x: 0.5, y: 0.5)
                        .foregroundColor(Color(hex: 0xF73E6C))
                        .padding(.trailing, 5)
                    }
                    .padding(7)
                }
            }
            .background(Color.white)
            .foregroundColor(Color.black)
            .cornerRadius(10)
            .shadow(color: .gray, radius: 2, x: 1, y: 1)
            .padding(.horizontal, 12)
            .padding(.bottom, 2)
        }
        .padding(10)
        .onAppear {
            Task {
                await loadData()
            }
        }
    }
    
    func loadData() async {
        guard let url = URL(string: "http://localhost:5500/api/plan") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, meta) = try await URLSession.shared.data(from: url)
            print(meta)
            do {
                let decodedResponse = try JSONDecoder().decode(PlanListResponse.self, from: data)
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
    PlanList()
}
