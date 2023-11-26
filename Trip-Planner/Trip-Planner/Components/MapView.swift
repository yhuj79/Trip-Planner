import SwiftUI
import MapKit

struct MapView: View {
    var title: String
    var latitude: Double
    var longitude: Double
    
    
    var body: some View {
        VStack {
            Map(initialPosition: .region(region))
        }
        .navigationBarTitle("\(title)", displayMode: .inline)
    }
    
    private var region: MKCoordinateRegion {
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
            span: MKCoordinateSpan(latitudeDelta: 0.007, longitudeDelta: 0.007)
        )
    }
}
