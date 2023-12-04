import SwiftUI

// 숙소 목록 API 응답을 파싱하는 모델
struct PlanAllAccommodationResponse: Codable {
    var results: [PlanAllAccommodationResult]
}

// 관광지 목록 API 응답을 파싱하는 모델
struct PlanAllTSpotResponse: Codable {
    var results: [PlanAllTSpotResult]
}

// 숙소 정보를 나타내는 모델
struct PlanAllAccommodationResult: Codable, Identifiable {
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

// 관광지 정보를 나타내는 모델
struct PlanAllTSpotResult: Codable, Identifiable {
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

// 새 일정 생성 화면을 나타내는 뷰
struct PlanCreateAll: View {
    // 숙소 및 관광지 목록 결과를 담을 배열
    @State private var results_a = [PlanAllAccommodationResult]()
    @State private var results_t = [PlanAllTSpotResult]()
    
    // 선택된 숙소 및 관광지 ID를 담을 Set
    @State private var selectedAccommodations = Set<Int>()
    @State private var selectedSpots = Set<Int>()
    
    // 일정 제목 및 알림 표시 여부를 관리하는 변수들
    @State private var scheduleTitle = ""
    @State private var showCompleteAlert = false
    @State private var showErrorAlert = false
    
    // 선택된 국가 정보를 담을 변수
    @State var selectedACountry: String = ""
    @State var selectedTCountry: String = ""
    
    // 부모 뷰에서 전달된 Modal 표시 여부를 관리하는 바인딩 변수
    @Binding var showModal: Bool
    
    var body: some View {
        // 네비게이션 뷰로 감싼 스크롤 가능한 뷰
        NavigationView {
            ScrollView {
                // 세로로 쌓인 UI 요소들을 나타내는 LazyVStack
                LazyVStack(alignment: .leading, spacing: 10) {
                    // 일정 이름 입력란
                    Text("일정 이름")
                        .foregroundColor(Color.black)
                        .font(.system(size: 22))
                        .bold()
                        .padding(.top, 18)
                        .padding(.leading, 18)
                    
                    TextField("등록할 일정 이름을 입력하세요", text: $scheduleTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .shadow(color: .gray, radius: 1, x: 0.7, y: 0.7)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 2)
                }
                
                // 숙소 선택 섹션
                LazyVStack(alignment: .leading) {
                    Text("숙소 선택")
                        .foregroundColor(Color.black)
                        .font(.system(size: 22))
                        .bold()
                        .padding(.top, 10)
                        .padding(.leading, 18)
                        .padding(.bottom, -5)
                    
                    // 국가 선택 세그먼트 컨트롤
                    Picker("Select Country", selection: $selectedACountry) {
                        Text("전체").tag("")
                        Text("프랑스").tag("프랑스")
                        Text("영국").tag("영국")
                        Text("독일").tag("독일")
                        Text("미국").tag("미국")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal, 22)
                    .padding(.top, 10)
                    .padding(.bottom, 3)
                    
                    // 숙소 목록을 나타내는 LazyVGrid
                    LazyVGrid(columns: Array(repeating: GridItem(), count: 1), spacing: 4) {
                        ForEach(results_a.filter { selectedACountry.isEmpty || $0.country == selectedACountry }) { accommodation in
                            // 각 숙소 항목을 나타내는 VStack
                            VStack {
                                HStack {
                                    // 숙소 이미지
                                    AsyncImage(url: accommodation.image_url)
                                        .frame(width: 50, height: 50)
                                        .cornerRadius(8)
                                        .overlay (
                                            Rectangle()
                                                .fill(Color.black.opacity(0.05))
                                                .cornerRadius(8)
                                        )
                                    
                                    // 숙소 정보 텍스트
                                    VStack(alignment: .leading) {
                                        Text(accommodation.name)
                                            .font(.system(size: 14))
                                            .bold()
                                            .padding(.bottom, 1)
                                        Text(accommodation.intl_name)
                                            .font(.system(size: 12))
                                    }
                                    
                                    Spacer()
                                    
                                    // 숙소 선택 버튼
                                    Button(action: {
                                        toggleSelection(id: accommodation.id, type: .accommodation)
                                    }) {
                                        Image(systemName: selectedAccommodations.contains(accommodation.id) ? "checkmark.square.fill" : "square")
                                            .resizable()
                                            .frame(width: 22, height: 22)
                                            .foregroundColor(Color(hex: 0xF73E6C))
                                            .padding(.trailing, 10)
                                    }
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
                            await loadAccommodationData()
                        }
                    }
                }
                
                // 관광지 선택 섹션
                LazyVStack(alignment: .leading) {
                    Text("관광지 선택")
                        .foregroundColor(Color.black)
                        .font(.system(size: 22))
                        .bold()
                        .padding(.top, 10)
                        .padding(.leading, 18)
                        .padding(.bottom, -5)
                    
                    // 국가 선택 세그먼트 컨트롤
                    Picker("Select Country", selection: $selectedTCountry) {
                        Text("전체").tag("")
                        Text("프랑스").tag("프랑스")
                        Text("영국").tag("영국")
                        Text("독일").tag("독일")
                        Text("미국").tag("미국")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal, 22)
                    .padding(.top, 10)
                    .padding(.bottom, 3)
                    
                    // 관광지 목록을 나타내는 LazyVGrid
                    LazyVGrid(columns: Array(repeating: GridItem(), count: 1), spacing: 4) {
                        ForEach(results_t.filter { selectedTCountry.isEmpty || $0.country == selectedTCountry }) { spot in
                            // 각 관광지 항목을 나타내는 VStack
                            VStack {
                                HStack {
                                    // 관광지 이미지
                                    AsyncImage(url: spot.image_url)
                                        .frame(width: 50, height: 50)
                                        .cornerRadius(8)
                                        .overlay (
                                            Rectangle()
                                                .fill(Color.black.opacity(0.05))
                                                .cornerRadius(8)
                                        )
                                    
                                    // 관광지 정보 텍스트
                                    VStack(alignment: .leading) {
                                        Text(spot.name)
                                            .font(.system(size: 14))
                                            .bold()
                                            .padding(.bottom, 1)
                                        Text(spot.intl_name)
                                            .font(.system(size: 12))
                                    }
                                    
                                    Spacer()
                                    
                                    // 관광지 선택 버튼
                                    Button(action: {
                                        toggleSelection(id: spot.id, type: .touristSpot)
                                    }) {
                                        Image(systemName: selectedSpots.contains(spot.id) ? "checkmark.square.fill" : "square")
                                            .resizable()
                                            .frame(width: 22, height: 22)
                                            .foregroundColor(Color(hex: 0xF73E6C))
                                            .padding(.trailing, 10)
                                    }
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
                            await loadTSpotData()
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    // 등록 버튼
                    Button("등록") {
                        if scheduleTitle.count > 0 && selectedAccommodations.count > 0 && selectedSpots.count > 0 {
                            insertPlan()
                        } else {
                            showErrorAlert.toggle()
                        }
                    }
                    .foregroundColor(Color(hex: 0xF73E6C))
                }
                ToolbarItem(placement: .cancellationAction) {
                    // 취소 버튼
                    Button("취소", role: .cancel) {
                        self.showModal = false
                    }
                    .foregroundColor(Color(hex: 0xF73E6C))
                }
            }
            // 등록 실패 알림
            .alert(isPresented: $showErrorAlert) {
                Alert(title: Text("등록 실패"), message: Text("정보를 입력해 주세요."))
            }
        }
        // 등록 완료 알림
        .alert(isPresented: $showCompleteAlert) {
            Alert(title: Text("일정"), message: Text("등록이 완료되었습니다."),
                  dismissButton: .default(Text("확인")) {
                self.showModal = false
            })
        }
    }
    
    enum SelectionType {
        case accommodation
        case touristSpot
    }
    
    // 숙소 및 관광지 선택 상태를 토글하는 함수
    func toggleSelection(id: Int, type: SelectionType) {
        switch type {
        case .accommodation:
            selectedAccommodations.removeAll()
            
            if selectedAccommodations.contains(id) {
                selectedAccommodations.remove(id)
            } else {
                selectedAccommodations.insert(id)
            }
        case .touristSpot:
            if selectedSpots.contains(id) {
                selectedSpots.remove(id)
            } else {
                selectedSpots.insert(id)
            }
        }
    }
    
    // 숙소 데이터를 비동기적으로 로드하는 함수
    func loadAccommodationData() async {
        guard let url = URL(string: "http://localhost:5500/api/accommodation") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, meta) = try await URLSession.shared.data(from: url)
            print(meta)
            
            do {
                var decodedResponse = try JSONDecoder().decode(PlanAllAccommodationResponse.self, from: data)
                
                // 국가가 선택되었을 경우 해당 국가의 데이터만 필터링
                if !selectedACountry.isEmpty {
                    decodedResponse.results = decodedResponse.results.filter { $0.country == selectedACountry }
                }
                
                let updatedResponse = decodedResponse
                
                Task {
                    DispatchQueue.main.async {
                        self.results_a = updatedResponse.results
                    }
                }
            } catch let jsonError as NSError {
                print("JSON decode failed: \(jsonError.localizedDescription)")
            }
        } catch {
            print("Invalid data")
        }
    }
    
    // 관광지 데이터를 비동기적으로 로드하는 함수
    func loadTSpotData() async {
        guard let url = URL(string: "http://localhost:5500/api/tourist_spot") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, meta) = try await URLSession.shared.data(from: url)
            print(meta)
            
            do {
                var decodedResponse = try JSONDecoder().decode(PlanAllTSpotResponse.self, from: data)
                
                // 국가가 선택되었을 경우 해당 국가의 데이터만 필터링
                if !selectedTCountry.isEmpty {
                    decodedResponse.results = decodedResponse.results.filter { $0.country == selectedTCountry }
                }
                
                let updatedResponse = decodedResponse
                
                Task {
                    DispatchQueue.main.async {
                        self.results_t = updatedResponse.results
                    }
                }
            } catch let jsonError as NSError {
                print("JSON decode failed: \(jsonError.localizedDescription)")
            }
        } catch {
            print("Invalid data")
        }
    }
    
    // 일정을 등록하는 함수
    func insertPlan() {
        Task {
            var accommodationsList = ""
            var spotList = ""
            
            // 선택된 숙소 ID를 문자열로 변환하여 리스트에 추가
            for accommodationsId in selectedAccommodations {
                accommodationsList += "\(accommodationsId)"
            }
            
            // 선택된 관광지 ID를 문자열로 변환하여 리스트에 추가
            for spotId in selectedSpots {
                spotList += "\(spotId)-"
            }
            
            do {
                guard let url = URL(string: "http://localhost:5500/api/plan/insert/\(scheduleTitle)/\(accommodationsList)/\(spotList)") else {
                    print("Invalid URL")
                    return
                }
                
                let (_, meta) = try await URLSession.shared.data(from: url)
                print(meta)
                // 완료 Alert 토글
                showCompleteAlert.toggle()
                
            } catch {
                print("Invalid data")
            }
        }
    }
}
