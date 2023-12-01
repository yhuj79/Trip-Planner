import SwiftUI

struct PlanAllAccommodationResponse: Codable {
    var results: [PlanAllAccommodationResult]
}

struct PlanAllTSpotResponse: Codable {
    var results: [PlanAllTSpotResult]
}

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

struct PlanCreateAll: View {
    @State private var results_a = [PlanAllAccommodationResult]()
    @State private var results_t = [PlanAllTSpotResult]()
    @State private var selectedAccommodations = Set<Int>()
    @State private var selectedSpots = Set<Int>()
    @State private var scheduleTitle = ""
    @State private var showCompleteAlert = false
    @State private var showErrorAlert = false
    @Binding var showModal: Bool
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 10) {
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
                LazyVStack(alignment: .leading) {
                    Text("숙소 선택")
                        .foregroundColor(Color.black)
                        .font(.system(size: 22))
                        .bold()
                        .padding(.top, 10)
                        .padding(.leading, 18)
                        .padding(.bottom, -5)
                    Spacer()
                    LazyVGrid(columns: Array(repeating: GridItem(), count: 1), spacing: 4) {
                        ForEach(results_a) { accommodation in
                            VStack {
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
                LazyVStack(alignment: .leading) {
                    Text("관광지 선택")
                        .foregroundColor(Color.black)
                        .font(.system(size: 22))
                        .bold()
                        .padding(.top, 10)
                        .padding(.leading, 18)
                        .padding(.bottom, -5)
                    LazyVGrid(columns: Array(repeating: GridItem(), count: 1), spacing: 4) {
                        ForEach(results_t) { spot in
                            VStack {
                                HStack {
                                    AsyncImage(url: spot.image_url)
                                        .frame(width: 50, height: 50)
                                        .cornerRadius(8)
                                        .overlay (
                                            Rectangle()
                                                .fill(Color.black.opacity(0.05))
                                                .cornerRadius(8)
                                        )
                                    VStack(alignment: .leading) {
                                        Text(spot.name)
                                            .font(.system(size: 14))
                                            .bold()
                                            .padding(.bottom, 1)
                                        Text(spot.intl_name)
                                            .font(.system(size: 12))
                                    }
                                    Spacer()
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
                    Button("취소", role: .cancel) {
                        self.showModal = false
                    }
                    .foregroundColor(Color(hex: 0xF73E6C))
                }
            }
            .alert(isPresented: $showErrorAlert) {
                Alert(title: Text("등록 실패"), message: Text("정보를 입력해 주세요."))
            }
        }
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
    
    func loadAccommodationData() async {
        guard let url = URL(string: "http://localhost:5500/api/accommodation") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, meta) = try await URLSession.shared.data(from: url)
            print(meta)
            do {
                let decodedResponse = try JSONDecoder().decode(PlanAllAccommodationResponse.self, from: data)
                DispatchQueue.main.async {
                    self.results_a = decodedResponse.results
                }
            } catch let jsonError as NSError {
                print("JSON decode failed: \(jsonError.localizedDescription)")
            }
        } catch {
            print("Invalid data")
        }
    }
    
    func loadTSpotData() async {
        guard let url = URL(string: "http://localhost:5500/api/tourist_spot") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, meta) = try await URLSession.shared.data(from: url)
            print(meta)
            do {
                let decodedResponse = try JSONDecoder().decode(PlanAllTSpotResponse.self, from: data)
                DispatchQueue.main.async {
                    self.results_t = decodedResponse.results
                }
            } catch let jsonError as NSError {
                print("JSON decode failed: \(jsonError.localizedDescription)")
            }
        } catch {
            print("Invalid data")
        }
    }
    
    func insertPlan() {
        Task {
            var accommodationsList = ""
            var spotList = ""
            
            for accommodationsId in selectedAccommodations {
                accommodationsList += "\(accommodationsId)"
            }
            
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
                showCompleteAlert.toggle()
                
            } catch {
                print("Invalid data")
            }
        }
    }
}
