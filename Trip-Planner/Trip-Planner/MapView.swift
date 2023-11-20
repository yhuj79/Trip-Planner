import SwiftUI
import MapKit

struct MapView: View {
    var body: some View {
        Map(initialPosition: .region(region))
    }
    
    private var region: MKCoordinateRegion {
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.575843, longitude: 126.977380),
            span: MKCoordinateSpan(latitudeDelta: 0.007, longitudeDelta: 0.007)
        )
    }
}

#Preview {
    MapView()
}
