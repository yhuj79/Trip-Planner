import SwiftUI
import MapKit

struct LocationResponse: Codable {
    var results: [LocationResult]
}

struct LocationResult: Codable, Identifiable {
    let id: Int
    let name: String
    let latitude: Double
    let longitude: Double
}

struct AnnotationItem: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let name: String
}

extension AnnotationItem {
    static var example = AnnotationItem(coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0), name: "")
}

struct PlanDetail: View {
    var plan: PlanListResult
    var spotArray: [Int]
    @State private var locationResponse: LocationResponse? = nil
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 0.07, longitudeDelta: 0.07)
    )
    
    var body: some View {
        ScrollView {
            Button(action: {
                print("\(plan)")
            }) {
                HStack {
                    Text("Print Plan")
                }
                .frame(width: UIScreen.main.bounds.width - 70)
                .padding(.vertical, 15)
            }
            VStack {
                Map(coordinateRegion: $region, annotationItems: [AnnotationItem.example] + additionalAnnotations()) { item in
                    MapAnnotation(coordinate: item.coordinate) {
                        VStack {
                            Image(systemName: "mappin.circle.fill")
                                .foregroundColor(Color.red)
                                .background(
                                    Circle().fill(Color.white)
                                )
                                .frame(width: 22, height: 22)
                            Text(item.name)
                                .lineLimit(nil)
                                .fixedSize(horizontal: true, vertical: true)
                                .multilineTextAlignment(.center)
                                .font(.caption)
                                .foregroundColor(.primary)
                                .padding(.horizontal, 5)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                                .shadow(radius: 5)
                        }
                    }
                }
            }
            .frame(height: 330)
            VStack {
                Identification(id: plan.accommodation, target: "accommodation")
                    .font(.system(size: 12))
                ForEach(plan.spotArray, id: \.self) { id in
                    Identification(id: id, target: "tourist_spot")
                        .font(.system(size: 12))
                }
            }
            .toolbar {
                ToolbarItem {
                    Menu {} label: {
                        Label("Menu", systemImage: "ellipsis.circle")
                    }
                }
            }
            .navigationBarTitle("\(plan.name)", displayMode: .inline)
        }
        .onAppear {
            Task {
                locationResponse = await loadData(target: "accommodation", id: plan.accommodation)
                await loadSpotCoordinates()
                updateRegionWithCoordinates()
            }
        }
    }
    
    func loadSpotCoordinates() async {
        for spotID in spotArray {
            let spotResponse = await loadData(target: "tourist_spot", id: spotID)
            locationResponse?.results.append(contentsOf: spotResponse.results)
        }
    }
    
    func updateRegionWithCoordinates() {
        guard let locationResponse = locationResponse else {
            return
        }
        
        let averageLatitude = locationResponse.results.reduce(0.0) { $0 + $1.latitude } / Double(locationResponse.results.count)
        let averageLongitude = locationResponse.results.reduce(0.0) { $0 + $1.longitude } / Double(locationResponse.results.count)
        
        region.center = CLLocationCoordinate2D(latitude: averageLatitude, longitude: averageLongitude)
    }
    
    func loadData(target: String, id: Int) async -> LocationResponse {
        guard let url = URL(string: "http://localhost:5500/api/\(target)/identification/\(id)") else {
            print("Invalid URL")
            return LocationResponse(results: [])
        }
        
        do {
            let (data, meta) = try await URLSession.shared.data(from: url)
            print(meta)
            do {
                let decodedResponse = try JSONDecoder().decode(LocationResponse.self, from: data)
                return decodedResponse
            } catch let jsonError as NSError {
                print("JSON decode failed: \(jsonError.localizedDescription)")
                return LocationResponse(results: [])
            }
        } catch {
            print("Invalid data")
            return LocationResponse(results: [])
        }
    }
    
    private func additionalAnnotations() -> [AnnotationItem] {
        guard let locationResponse = locationResponse else {
            return []
        }
        
        return locationResponse.results.map {
            AnnotationItem(coordinate: CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude), name: $0.name)
        }
    }
}
