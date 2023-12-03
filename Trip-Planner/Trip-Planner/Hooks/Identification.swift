import SwiftUI

// 서버 응답에서 식별 정보를 나타내는 Codable 구조체
struct IdentificationResponse: Codable {
    var results: [IdentificationResult]
}

// 식별 정보를 나타내는 Codable 및 Identifiable 구조체
struct IdentificationResult: Codable, Identifiable {
    let id: Int
    let name: String
    let latitude: Double
    let longitude: Double
}

// 식별 정보를 가져와 화면에 표시하는 뷰
// 숙소 또는 관광지의 id를 받으면 식별하여 이름과 좌표 출력
struct Identification: View {
    // 뷰에 필요한 속성
    let id: Int
    let target: String
    @State private var results = [IdentificationResult]()
    
    var body: some View {
        VStack {
            // 결과 목록을 순회하며 이름을 표시하는 뷰
            ForEach(results) { identificationResult in
                Text("\(identificationResult.name)")
            }
        }
        .onAppear {
            // 화면이 나타날 때 비동기로 데이터를 가져오는 Task 호출
            Task {
                await loadData()
            }
        }
    }
    
    // 서버로부터 데이터를 비동기로 가져오는 함수
    func loadData() async {
        // URL 생성
        guard let url = URL(string: "http://localhost:5500/api/\(target)/identification/\(id)") else {
            print("Invalid URL")
            return
        }
        
        do {
            // 비동기로 데이터를 가져오고 메타데이터 출력
            let (data, meta) = try await URLSession.shared.data(from: url)
            print(meta)
            
            do {
                // JSON 디코딩을 통해 응답 데이터를 해석하고 메인 스레드에서 결과 갱신
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
