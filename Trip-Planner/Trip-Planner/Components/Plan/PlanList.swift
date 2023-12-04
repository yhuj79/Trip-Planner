import SwiftUI

// 일정 목록 API 응답을 파싱하는 모델
struct PlanListResponse: Codable {
    var results: [PlanListResult]
}

// 일정 목록 결과를 나타내는 모델
struct PlanListResult: Codable, Identifiable {
    let id: Int
    let name: String
    let accommodation: Int
    let spot_list: String
    
    // spot_list를 파싱하여 Int 배열로 반환하는 computed property
    var spotArray: [Int] {
        return spot_list.components(separatedBy: "-").compactMap { Int($0) }
    }
}

// 일정 목록을 나타내는 뷰
struct PlanList: View {
    // 일정 목록 결과를 담을 배열
    @State private var results = [PlanListResult]()
    
    var body: some View {
        // 수평 LazyVGrid를 사용하여 UI 구성
        LazyVGrid(columns: Array(repeating: GridItem(), count: 1), spacing: 4) {
            // 일정이 없을 경우 안내 메시지 표시
            if results.count == 0 {
                VStack {
                    Text("등록된 일정이 없습니다.")
                }
                .padding(.vertical, 100)
            }
            // 일정이 있는 경우 해당 일정을 나타내는 뷰 표시
            ForEach(results) { plan in
                NavigationLink(destination: PlanDetail(plan: plan, spotArray: plan.spotArray)) {
                    // 일정 정보를 나타내는 HStack
                    HStack {
                        // 일정 이름 및 숙소 정보를 나타내는 VStack
                        VStack(alignment: .leading) {
                            Text(plan.name)
                                .font(.system(size: 16))
                                .bold()
                                .padding(.bottom, 2)
                            Identification(id: plan.accommodation, target: "accommodation")
                                .font(.system(size: 12))
                            // 관광지 id 값을 Identification 컴포넌트를 활용하여 이름으로 출력
                            ForEach(plan.spotArray.prefix(5), id: \.self) { id in
                                Identification(id: id, target: "tourist_spot")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                            }
                            // 5개 이상일 경우 축약
                            if plan.spotArray.count > 5 {
                                Text("...")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(5)
                        Spacer()
                        
                        // 일정 수정을 위한 버튼 (현재 기능 없음)
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
        // 뷰가 나타날 때 데이터를 비동기적으로 로드
        .onAppear {
            Task {
                await loadData()
            }
        }
    }
    
    // API를 통해 일정 목록 정보를 비동기적으로 로드
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
